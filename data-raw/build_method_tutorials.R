# AdamsAnalysis Step 8.5 — build method tutorials dataset
# Run from the package ROOT: source("data-raw/build_method_tutorials.R")
if (!file.exists("DESCRIPTION") || !file.exists("data/analysis_catalogue.rda")) {
  stop("Open the AdamsAnalysis package project before running this script.")
}
method_tutorials <- read.csv(
  "data-raw/method_tutorials.csv", stringsAsFactors=FALSE,
  fileEncoding="UTF-8", check.names=FALSE
)
expected <- c(
  "method_id", "method_name", "study_data", "learning_goal",
  "r_packages", "python_packages", "r_code", "python_code",
  "output_to_inspect", "limitations_and_checks", "implementation_note"
)
reference_env <- new.env(parent=baseenv())
load("data/analysis_catalogue.rda", envir=reference_env)
reference <- reference_env$analysis_catalogue
stopifnot(
  identical(names(method_tutorials), expected),
  nrow(method_tutorials) == 73L,
  !anyDuplicated(method_tutorials$method_id),
  identical(method_tutorials$method_id, reference$method_id),
  identical(method_tutorials$method_name, reference$method_name),
  !anyNA(method_tutorials),
  all(vapply(method_tutorials, function(x) all(nzchar(trimws(x))), logical(1)))
)
# Check that all stored R tutorial examples at least parse without execution.
for (i in seq_len(nrow(method_tutorials))) {
  tryCatch(
    parse(text=method_tutorials$r_code[i]),
    error=function(e) stop("R tutorial syntax invalid for ",
                           method_tutorials$method_id[i], ": ", conditionMessage(e))
  )
}
usethis::use_data(method_tutorials, overwrite=TRUE)
message("Saved 73 method tutorials to data/method_tutorials.rda")
