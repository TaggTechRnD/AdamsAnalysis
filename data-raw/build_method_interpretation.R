# AdamsAnalysis - Step 8.4: build results and interpretation reference
# Run from the ROOT of the AdamsAnalysis package:
# source("data-raw/build_method_interpretation.R")

if (!file.exists("DESCRIPTION") || !file.exists("data/analysis_catalogue.rda")) {
  stop("Open the AdamsAnalysis package project and run this script from its root.")
}

method_interpretation <- read.csv(
  "data-raw/method_interpretation.csv",
  stringsAsFactors = FALSE,
  fileEncoding = "UTF-8",
  check.names = FALSE
)

expected_columns <- c(
  "method_id", "method_name", "primary_outputs", "inference_and_tests",
  "effect_sizes_and_intervals", "fit_and_performance_metrics",
  "interpretation_guidance", "common_misinterpretations", "reporting_example"
)

reference_env <- new.env(parent = baseenv())
load("data/analysis_catalogue.rda", envir = reference_env)
reference <- reference_env$analysis_catalogue

stopifnot(
  identical(names(method_interpretation), expected_columns),
  nrow(method_interpretation) == 73L,
  !anyDuplicated(method_interpretation$method_id),
  identical(method_interpretation$method_id, reference$method_id),
  identical(method_interpretation$method_name, reference$method_name),
  !anyNA(method_interpretation),
  all(vapply(method_interpretation, function(col) {
    all(nzchar(trimws(col)))
  }, logical(1)))
)

usethis::use_data(method_interpretation, overwrite = TRUE)
message("Saved ", nrow(method_interpretation),
        " interpretation entries to data/method_interpretation.rda")
