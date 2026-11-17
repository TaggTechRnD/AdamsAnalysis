# AdamsAnalysis - Step 8.3: build assumptions and diagnostic reference
# Run from the ROOT of the AdamsAnalysis package:
# source("data-raw/build_method_diagnostics.R")

if (!file.exists("DESCRIPTION") || !file.exists("data/analysis_catalogue.rda")) {
  stop("Open the AdamsAnalysis package project and run this script from its root.")
}

method_diagnostics <- read.csv(
  "data-raw/method_diagnostics.csv",
  stringsAsFactors = FALSE,
  fileEncoding = "UTF-8",
  check.names = FALSE
)

expected_columns <- c(
  "method_id", "method_name", "catalogue_assumption_checks",
  "assumptions_and_conditions", "diagnostic_procedures", "if_violated",
  "diagnostic_caveats"
)

reference_env <- new.env(parent = baseenv())
load("data/analysis_catalogue.rda", envir = reference_env)
reference <- reference_env$analysis_catalogue

stopifnot(
  identical(names(method_diagnostics), expected_columns),
  nrow(method_diagnostics) == 73L,
  !anyDuplicated(method_diagnostics$method_id),
  identical(method_diagnostics$method_id, reference$method_id),
  identical(method_diagnostics$method_name, reference$method_name),
  identical(method_diagnostics$catalogue_assumption_checks,
            reference$assumption_checks),
  !anyNA(method_diagnostics),
  all(vapply(method_diagnostics, function(z) all(nzchar(trimws(z))), logical(1)))
)

usethis::use_data(method_diagnostics, overwrite = TRUE)
message("Saved ", nrow(method_diagnostics),
        " method diagnostics to data/method_diagnostics.rda")
