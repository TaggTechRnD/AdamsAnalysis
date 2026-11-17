# AdamsAnalysis - Step 8.2: build mathematical method reference
# Run from the ROOT of the AdamsAnalysis package:
# source("data-raw/build_method_mathematics.R")

if (!file.exists("DESCRIPTION") || !file.exists("data/analysis_catalogue.rda")) {
  stop("Open the AdamsAnalysis package project and run this script from its root.")
}

method_mathematics <- read.csv(
  "data-raw/method_mathematics.csv",
  stringsAsFactors = FALSE,
  fileEncoding = "UTF-8",
  check.names = FALSE
)

expected_columns <- c(
  "method_id", "method_name", "foundation_type", "equation_latex",
  "symbol_definitions", "mathematical_explanation", "scope_note"
)

e <- new.env(parent = baseenv())
load("data/analysis_catalogue.rda", envir = e)
reference <- e$analysis_catalogue

stopifnot(
  identical(names(method_mathematics), expected_columns),
  nrow(method_mathematics) == 73L,
  !anyDuplicated(method_mathematics$method_id),
  identical(method_mathematics$method_id, reference$method_id),
  identical(method_mathematics$method_name, reference$method_name),
  !anyNA(method_mathematics),
  all(vapply(method_mathematics, function(z) all(nzchar(trimws(z))), logical(1)))
)

usethis::use_data(method_mathematics, overwrite = TRUE)
message("Saved ", nrow(method_mathematics), " mathematical entries to data/method_mathematics.rda")
