
#' Create an AdamsAnalysis HTML Report
#'
#' @param answers Named list of questionnaire responses.
#' @param result Output from recommend_methods().
#' @return A complete HTML report as a character string.
#' @export
create_report_html <- function(answers, result = NULL) {

  validate_answers(answers)

  # Escape text before placing it into HTML
  esc <- function(x) {
    x <- as.character(x)
    x[is.na(x)] <- ""
    x <- gsub("&", "&amp;", x, fixed = TRUE)
    x <- gsub("<", "&lt;", x, fixed = TRUE)
    x <- gsub(">", "&gt;", x, fixed = TRUE)
    x <- gsub('"', "&quot;", x, fixed = TRUE)
    x
  }

  field <- function(label, value) {
    if (length(value) == 0 || is.na(value[1]) ||
        !nzchar(as.character(value[1]))) return("")

    paste0("<p><b>", esc(label), ":</b> ",
           esc(value[1]), "</p>")
  }

  # Build questionnaire summary
  ids <- names(answers)

  questions <- questionnaire$question[
    match(ids, questionnaire$question_id)
  ]

  values <- vapply(ids, function(id) {
    value <- as.character(answers[[id]])

    if (id == "Q10") return(value)

    opts <- questionnaire_options[
      questionnaire_options$question_id == id, ]

    i <- match(value, opts$option_value)

    if (is.na(i)) value else opts$option_label[i]
  }, character(1))

  rows <- paste0(
    "<tr><td>", esc(questions), "</td><td>",
    esc(values), "</td></tr>",
    collapse = "\n"
  )

  # Format each recommended method
  method_html <- function(df) {

    if (is.null(df) || nrow(df) == 0) {
      return("<p>No method selected.</p>")
    }

    get_value <- function(i, column) {
      if (column %in% names(df)) df[[column]][i] else ""
    }

    paste(vapply(seq_len(nrow(df)), function(i) {
      paste0(
        "<div class='method'>",
        "<h3>", esc(df$method_name[i]), "</h3>",
        field("Eligibility", get_value(i, "status")),
        field("Description", get_value(i, "description")),
        field("When to use", get_value(i, "when_to_use")),
        field("Research example", get_value(i, "example")),
        field("Assumptions", get_value(i, "assumptions_to_check")),
        field("Requirements to verify",
              get_value(i, "unverified_requirements")),
        field("Warnings", get_value(i, "assumption_flags")),
        "</div>"
      )
    }, character(1)), collapse = "\n")
  }

  # Handle incomplete questionnaires
  if (is.null(result)) {
    result <- list(
      status = "not_evaluated",
      message = "Select a research objective to begin.",
      primary = NULL,
      alternatives = NULL,
      missing_questions = NULL
    )
  }

  missing_html <- ""
  if (!is.null(result$missing_questions) &&
      nrow(result$missing_questions) > 0) {
    missing_html <- paste0(
      "<section><h2>Additional questions to consider</h2><ul>",
      paste0(
        "<li>", esc(result$missing_questions$question),
        "</li>", collapse = ""
      ),
      "</ul></section>"
    )
  }

  # Assemble a standalone HTML document
  paste0(
    "<!DOCTYPE html><html lang='en'><head>",
    "<meta charset='UTF-8'>",
    "<title>AdamsAnalysis Report</title>",
    "<style>",
    "body{font-family:Segoe UI,Arial,sans-serif;",
    "max-width:900px;margin:35px auto;padding:20px;",
    "background:#f4f7fb;color:#243447;}",
    "h1,h2,h3{color:#183b63;}",
    "section{background:white;padding:20px;",
    "border-radius:10px;margin-bottom:18px;}",
    "table{width:100%;border-collapse:collapse;}",
    "td,th{padding:9px;text-align:left;",
    "border-bottom:1px solid #e4eaf1;}",
    "th{background:#eaf1f8;}",
    ".method{padding:8px 0;border-bottom:1px solid #eee;}",
    ".muted{color:#64748b;}",
    "@media print{body{background:white;}",
    "section{break-inside:avoid;}}",
    "</style></head><body>",

    "<h1>AdamsAnalysis</h1>",
    "<p class='muted'>Statistical Analysis Report — ",
    esc(as.character(Sys.Date())), "</p>",

    "<section><h2>Research Summary</h2>",
    "<table><tr><th>Question</th><th>Answer</th></tr>",
    rows, "</table></section>",

    "<section><h2>Assessment</h2>",
    field("Status", gsub("_", " ", result$status)),
    "<p>", esc(result$message), "</p></section>",

    "<section><h2>Primary Recommendation</h2>",
    method_html(result$primary), "</section>",

    "<section><h2>Alternative Methods</h2>",
    method_html(result$alternatives), "</section>",

    missing_html,

    "<p class='muted'>Recommendations are provisional.",
    " Statistical assumptions must be independently verified.",
    "</p></body></html>"
  )
}
