
#' Launch AdamsAnalysis
#'
#' Opens the AdamsAnalysis Shiny dashboard.
#'
#' @export
launch_app <- function() {

  # Generate input controls from our questionnaire dataset

  make_question <- function(id, current = NULL) {

    q <- questionnaire$question[
      questionnaire$question_id == id
    ]

    # Sample size requires a numeric input
    if (id == "Q10") {

      value <- if (length(current) == 1L &&
                   is.numeric(current) &&
                   is.finite(current)) current else NA_real_

      return(shiny::numericInput(
        id, q, value = value,
        min = 1, step = 1, width = "100%"
      ))
    }

    opts <- questionnaire_options[
      questionnaire_options$question_id == id, ]

    # Preserve responses when the UI updates
    selected <- if (
      length(current) == 1L &&
      !is.na(current) &&
      current %in% opts$option_value
    ) current else "unknown"

    shiny::selectInput(
      inputId = id,
      label = q,
      choices = stats::setNames(
        opts$option_value, opts$option_label
      ),
      selected = selected,
      width = "100%"
    )
  }


  # UI --------------------------------------------------

  ui <- shiny::fluidPage(

    title = "AdamsAnalysis",

    shiny::tags$head(
      shiny::tags$style(shiny::HTML("
        body {
          background: #f4f7fb;
          font-family: 'Segoe UI', Arial, sans-serif;
          color: #243447;
        }

        .aa-header {
          padding: 28px 10px 22px;
        }

        .aa-header h2 {
          font-weight: 700;
          color: #183b63;
          margin: 8px 0;
        }

        .aa-muted {
          color: #718096;
        }

        .aa-label {
          color: #2878a8;
          font-size: 12px;
          font-weight: 700;
          letter-spacing: 1.5px;
        }

        .aa-card {
          background: white;
          border: 1px solid #e4eaf1;
          border-radius: 12px;
          padding: 25px;
          margin-bottom: 20px;
          box-shadow: 0 3px 12px rgba(0,0,0,0.035);
        }

        .aa-card h4 {
          font-weight: 650;
          color: #183b63;
          margin-top: 0;
          margin-bottom: 18px;
        }

        .aa-empty {
          background: #f7f9fc;
          border: 1px dashed #cbd5e1;
          border-radius: 8px;
          padding: 25px;
          text-align: center;
          color: #718096;
        }

        .form-group {
          margin-bottom: 20px;
        }

        .control-label {
          font-weight: 600;
          color: #34465a;
        }
      "))
    ),

    # Header
    shiny::div(
      class = "aa-header",
      shiny::div(class = "aa-label",
                 "STATISTICAL ANALYSIS ADVISOR:"),
      shiny::h2("AdamsAnalysis"),
      shiny::h3("An algorithmic aide memoire, designed to help you consider the appropriate statistical analysis for your research project."),
      shiny::p(
        class = "aa-muted",
        "Author: Adam Taggart PhD"
      )
    ),

    # Dashboard
    shiny::fluidRow(

      # Left: Questionnaire
      shiny::column(
        width = 4,

        shiny::div(
          class = "aa-card",
          shiny::h4("Research Design"),
          shiny::p(
            class = "aa-muted",
            "Describe your study using the questions below."
          ),
          shiny::textOutput("question_status"),
          shiny::uiOutput("questionnaire_ui")
        )
      ),

      # Right: Recommendations
      shiny::column(
        width = 8,

        shiny::div(
          class = "aa-card",
          shiny::h4("Recommended Analysis"),
          shiny::uiOutput("recommendation_ui")
        ),


        shiny::div(
          class = "aa-card",
          shiny::h4("Research Summary"),
          shiny::tableOutput("research_summary"),
          shiny::downloadButton(
            outputId = "download_report",
            label = "Download Analysis Report"
          )
        )

      )
    )
  )

  # Server ----------------------------------------------


  server <- function(input, output, session) {

    # Questions controlling conditional visibility
    parent_ids <- c(
      "Q01", "Q02", "Q04", "Q06",
      "Q07", "Q13", "Q14", "Q16"
    )

    # Determine which questions should appear
    visible_ids <- shiny::reactive({

      parent_answers <- stats::setNames(
        lapply(parent_ids, function(id) input[[id]]),
        parent_ids
      )

      # Remove unanswered inputs
      parent_answers <- parent_answers[
        vapply(parent_answers, function(x) {
          length(x) == 1L && !is.na(x)
        }, logical(1))
      ]

      visible_questions(parent_answers)
    })

    # Render currently relevant questions
    output$questionnaire_ui <- shiny::renderUI({

      ids <- visible_ids()

      shiny::tagList(
        lapply(ids, function(id) {
          current <- shiny::isolate(input[[id]])
          make_question(id, current)
        })
      )
    })

    # Collect responses from visible questions only
    answers <- shiny::reactive({

      ids <- visible_ids()

      x <- stats::setNames(
        lapply(ids, function(id) input[[id]]),
        ids
      )

      x[vapply(x, function(value) {
        length(value) == 1L && !is.na(value)
      }, logical(1))]
    })

    # Display questionnaire progress
    output$question_status <- shiny::renderText({

      x <- answers()

      answered <- sum(vapply(x, function(value) {
        !(is.character(value) && value == "unknown")
      }, logical(1)))

      paste(
        answered, "of", length(visible_ids()),
        "questions answered"
      )
    })


    # Generate recommendations whenever answers change
    recommendation <- shiny::reactive({

      a <- answers()

      # Wait until an objective has been selected
      if (is.null(a$Q01) || a$Q01 == "unknown") {
        return(NULL)
      }

      tryCatch(
        recommend_methods(a),
        error = function(e) {
          list(status = "error", message = conditionMessage(e))
        }
      )
    })

    # Display statistical recommendations
    output$recommendation_ui <- shiny::renderUI({

      r <- recommendation()

      if (is.null(r)) {
        return(shiny::div(
          class = "aa-empty",
          "Select a research objective to begin."
        ))
      }

      if (r$status == "error") {
        return(shiny::div(
          class = "aa-empty",
          shiny::strong("Recommendation error"),
          shiny::p(r$message)
        ))
      }

      shiny::tagList(

        # Recommendation status
        shiny::p(
          shiny::strong("Assessment: "),
          gsub("_", " ", r$status)
        ),

        shiny::p(r$message),

        # Primary recommendation
        if (nrow(r$primary) > 0) {

          shiny::tagList(
            shiny::hr(),
            shiny::h3(r$primary$method_name[1]),

            shiny::p(r$primary$description[1]),

            shiny::p(
              shiny::strong("When to use: "),
              r$primary$when_to_use[1]
            ),

            shiny::p(
              shiny::strong("Research example: "),
              r$primary$example[1]
            ),

            shiny::p(
              shiny::strong("Eligibility: "),
              r$primary$status[1]
            ),

            shiny::p(
              shiny::strong("Requirements to verify: "),
              r$primary$unverified_requirements[1]
            ),

            shiny::p(
              shiny::strong("Assumptions to check: "),
              r$primary$assumptions_to_check[1]
            ),

            if (nzchar(r$primary$assumption_flags[1])) {
              shiny::p(
                shiny::strong("Warnings: "),
                r$primary$assumption_flags[1]
              )
            }
          )
        },


        # Alternative methods
        if (nrow(r$alternatives) > 0) {

          shiny::tagList(
            shiny::hr(),
            shiny::h4("Other Potential Methods"),

            shiny::tags$ul(
              lapply(seq_len(nrow(r$alternatives)), function(i) {

                shiny::tags$li(
                  shiny::strong(
                    r$alternatives$method_name[i]
                  ),

                  paste0(
                    " (", r$alternatives$status[i], ")"
                  ),

                  shiny::p(
                    r$alternatives$when_to_use[i]
                  ),

                  if (nzchar(
                    r$alternatives$unverified_requirements[i]
                  )) {
                    shiny::p(
                      shiny::strong("To verify: "),
                      r$alternatives$unverified_requirements[i]
                    )
                  }
                )
              })
            )
          )
        },


        # Outstanding questionnaire items
        if (nrow(r$missing_questions) > 0) {

          shiny::p(
            class = "aa-muted",
            paste(
              nrow(r$missing_questions),
              "additional questions can help refine",
              "this recommendation."
            )
          )
        }
      )
    })


    # Display the researcher's selected parameters
    output$research_summary <- shiny::renderTable({

      a <- answers()

      if (length(a) == 0) {
        return(data.frame(
          Question = "No responses yet",
          Answer = ""
        ))
      }

      labels <- questionnaire$question[
        match(names(a), questionnaire$question_id)
      ]

      values <- vapply(names(a), function(id) {

        if (id == "Q10") {
          return(as.character(a[[id]]))
        }

        opts <- questionnaire_options[
          questionnaire_options$question_id == id, ]

        label <- opts$option_label[
          opts$option_value == a[[id]]
        ]

        if (length(label)) label[1]
        else as.character(a[[id]])

      }, character(1))

      data.frame(
        Question = labels,
        Answer = values
      )

    }, striped = TRUE, rownames = FALSE)

    output$download_report <- shiny::downloadHandler(

      filename = function() {
        paste0("AdamsAnalysis_", Sys.Date(), ".html")
      },

      content = function(file) {

        report <- create_report_html(
          answers(),
          recommendation()
        )

        writeLines(
          enc2utf8(report),
          con = file,
          useBytes = TRUE
        )
      },

      contentType = "text/html"
    )

  }


  shiny::runApp(
    shiny::shinyApp(ui, server),
    launch.browser = TRUE
  )
}
