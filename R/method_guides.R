#' Statistical Method Guides
#'
#' Descriptive educational reference material for the 73 statistical methods
#' in analysis_catalogue. The `method_id` field joins the two datasets.
#' Educational descriptions are initial drafts for expert QA/QC; mathematical
#' formulae, diagnostics, software examples, and references are planned later.
#'
#' @format A data frame with 73 rows and 9 columns:
#' \describe{
#'   \item{method_id}{Stable method key (AA01 through AA73).}
#'   \item{method_name}{Statistical method name.}
#'   \item{purpose}{Plain-language explanation of the method.}
#'   \item{research_questions}{Example research questions.}
#'   \item{design_requirements}{Study and data designs for which it is suitable.}
#'   \item{strengths}{Principal advantages.}
#'   \item{limitations}{Statistical and practical limitations.}
#'   \item{inappropriate_use}{Situations that make application or interpretation inappropriate.}
#'   \item{research_example}{Illustrative hypothetical applied study.}
#' }
"method_guides"
