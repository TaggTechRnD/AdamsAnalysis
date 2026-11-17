#' Statistical Method Tutorials in R and Python
#'
#' Self-contained educational simulations for the 73 methods in the
#' analysis_catalogue dataset. Each row contains runnable example code
#' strings for R and Python, explanatory goals, anticipated output and caveats.
#' Tutorials use synthetic data only. Some require optional libraries and
#' methods may have different implementations across languages.
#'
#' @format A data frame with 73 rows and 11 columns:
#' \describe{
#'   \item{method_id}{Stable analysis ID AA01 to AA73.}
#'   \item{method_name}{Statistical method name.}
#'   \item{study_data}{Description of synthetic sample design.}
#'   \item{learning_goal}{Question answered by the tutorial.}
#'   \item{r_packages}{R library dependencies.}
#'   \item{python_packages}{Python library dependencies.}
#'   \item{r_code}{Self-contained R code string.}
#'   \item{python_code}{Self-contained Python code string.}
#'   \item{output_to_inspect}{What to examine in the results.}
#'   \item{limitations_and_checks}{Assumptions and interpretation warnings.}
#'   \item{implementation_note}{Language-specific caveats or differences.}
#' }
"method_tutorials"
