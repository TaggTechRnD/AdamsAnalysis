#' Mathematical Foundations of Statistical Methods
#'
#' A reference for the 73 methods in analysis_catalogue, keyed by
#' `method_id`. Each row gives one representative mathematical expression,
#' notation, a plain-language interpretation, and a scope warning. The
#' expressions are educational starting points, not complete specifications
#' of every software implementation or proof of statistical suitability.
#'
#' @format A data frame with 73 rows and 7 columns:
#' \describe{
#'   \item{method_id}{Stable method key (AA01 through AA73).}
#'   \item{method_name}{Statistical method name.}
#'   \item{foundation_type}{Type of equation or mathematical rule.}
#'   \item{equation_latex}{Representative expression stored as LaTeX text.}
#'   \item{symbol_definitions}{Definitions of mathematical symbols.}
#'   \item{mathematical_explanation}{Plain-language explanation of the expression.}
#'   \item{scope_note}{Limitations and interpretation cautions for the expression.}
#' }
"method_mathematics"
