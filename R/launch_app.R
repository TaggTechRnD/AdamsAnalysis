
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
                 "STATISTICAL ANALYSIS ADVISOR"),
      shiny::h2("AdamsAnalysis"),
      shiny::p(
        class = "aa-muted",
        "AdamsAnalysis is a algorithmic aide memoire, designed to help you consider the appropriate statistical analysis for your research project."
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
          shiny::div(
            class = "aa-empty",
            "Your research characteristics will appear here."
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

    # Recommendations remain a placeholder
    output$recommendation_ui <- shiny::renderUI({
      shiny::div(
        class = "aa-empty",
        shiny::tags$strong("Not evaluated"),
        shiny::p(
          "Complete the questionnaire to identify suitable analyses."
        )
      )
    })
  }


  shiny::runApp(
    shiny::shinyApp(ui, server),
    launch.browser = TRUE
  )
}
