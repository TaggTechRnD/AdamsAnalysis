#' Results and Interpretation Guide for Statistical Methods
#'
#' Draft educational reference material for interpreting and reporting results
#' from the 73 statistical methods in the analysis_catalogue dataset. Each row
#' joins to the catalogue, method_guides, method_mathematics and
#' method_diagnostics through `method_id`. Reporting examples contain
#' placeholders, not actual study results. This dataset does not automate
#' statistical analysis or establish methodological suitability.
#'
#' @format A data frame with 73 rows and 9 columns:
#' \describe{
#'   \item{method_id}{Stable method identifier AA01 through AA73.}
#'   \item{method_name}{Full method name.}
#'   \item{primary_outputs}{Statistics or output objects typically reported.}
#'   \item{inference_and_tests}{Hypothesis tests, p-values and their availability or limitations.}
#'   \item{effect_sizes_and_intervals}{Appropriate effect measures and uncertainty intervals.}
#'   \item{fit_and_performance_metrics}{Fit, model-quality or predictive-performance metrics.}
#'   \item{interpretation_guidance}{Plain-language interpretation of common results.}
#'   \item{common_misinterpretations}{Frequent invalid interpretations to avoid.}
#'   \item{reporting_example}{Illustrative reporting template with placeholders.}
#' }
"method_interpretation"
