# AdamsAnalysis - Step 8.1: build descriptive statistical method guides
# Run from the ROOT of the AdamsAnalysis package:
# source("data-raw/build_method_guides.R")

if (!file.exists("DESCRIPTION") || !file.exists("data/analysis_catalogue.rda")) {
  stop("Open the AdamsAnalysis package project and run this script from its root.")
}

method_guides <- read.csv(
  "data-raw/method_guides.csv",
  stringsAsFactors = FALSE,
  fileEncoding = "UTF-8"
)

expected_columns <- c(
  "method_id", "method_name", "purpose", "research_questions",
  "design_requirements", "strengths", "limitations",
  "inappropriate_use", "research_example"
)

reference_env <- new.env(parent = baseenv())
load("data/analysis_catalogue.rda", envir = reference_env)
reference <- reference_env$analysis_catalogue

guide_fields <- setdiff(expected_columns, c("method_id", "method_name"))
stopifnot(
  identical(names(method_guides), expected_columns),
  nrow(method_guides) == 73L,
  !anyDuplicated(method_guides$method_id),
  identical(method_guides$method_id, reference$method_id),
  identical(method_guides$method_name, reference$method_name),
  !anyNA(method_guides),
  all(vapply(method_guides[guide_fields], function(z) all(nzchar(trimws(z))), logical(1)))
)

usethis::use_data(method_guides, overwrite = TRUE)
message("Saved ", nrow(method_guides), " method guides to data/method_guides.rda")
