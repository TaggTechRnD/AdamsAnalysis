#' Statistical Assumptions and Diagnostic Checks
#'
#' Educational assumptions, recommended checks, potential consequences of
#' violations and interpretive caveats for the 73 methods in
#' analysis_catalogue. Rows join to the catalogue using `method_id`.
#' These are diagnostic guidance, not automated evaluations of user data.
#'
#' @format A data frame with 73 rows and 7 columns:
#' \describe{
#'   \item{method_id}{Stable method key AA01 to AA73.}
#'   \item{method_name}{Statistical method name.}
#'   \item{catalogue_assumption_checks}{Unmodified assumption-check tags from the catalogue.}
#'   \item{assumptions_and_conditions}{Substantive assumptions and design conditions.}
#'   \item{diagnostic_procedures}{Checks, plots and analyses to investigate suitability.}
#'   \item{if_violated}{Consequences of problematic assumptions or data conditions.}
#'   \item{diagnostic_caveats}{Limits of diagnostics and important interpretation cautions.}
#' }
"method_diagnostics"
