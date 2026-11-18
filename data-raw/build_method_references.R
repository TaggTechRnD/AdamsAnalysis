# AdamsAnalysis — Step 8.6: bibliographic reference library.
# From the package root: source("data-raw/build_method_references.R")

if (!file.exists("DESCRIPTION") || !file.exists("data/analysis_catalogue.rda")) {
  stop("Open the AdamsAnalysis package project before running this script.")
}

method_references <- read.csv(
  "data-raw/method_references.csv", stringsAsFactors = FALSE,
  fileEncoding = "UTF-8", check.names = FALSE, na.strings = character()
)

expected <- c(
  "method_id", "method_name", "methodological_citation",
  "methodological_url", "methodological_reference_type",
  "applied_citation", "applied_url", "applied_context",
  "applied_status", "review_note"
)
reference_env <- new.env(parent = baseenv())
load("data/analysis_catalogue.rda", envir = reference_env)
reference <- reference_env$analysis_catalogue

stopifnot(
  identical(names(method_references), expected),
  nrow(method_references) == 73L,
  !anyDuplicated(method_references$method_id),
  identical(method_references$method_id, reference$method_id),
  identical(method_references$method_name, reference$method_name),
  !anyNA(method_references),
  all(nzchar(trimws(method_references$methodological_citation))),
  all(grepl("^https://", method_references$methodological_url)),
  all(nzchar(trimws(method_references$methodological_reference_type))),
  all(nzchar(trimws(method_references$applied_status))),
  all((method_references$applied_citation == "") ==
        (method_references$applied_url == "")),
  all(method_references$applied_url == "" |
        grepl("^https://", method_references$applied_url)),
  all((method_references$applied_status == "pending_applied_study") ==
        (method_references$applied_citation == ""))
)

usethis::use_data(method_references, overwrite = TRUE)
message("Saved ", nrow(method_references), " rows to data/method_references.rda")
message("Applied research citations needing selection: ",
        sum(method_references$applied_status == "pending_applied_study"))
