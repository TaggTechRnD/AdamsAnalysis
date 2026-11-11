
# AdamsAnalysis - Step 5.2: Recommendation QA/QC

devtools::load_all()

source("tests/testthat/helper-research_scenarios.R")

# Evaluate each independently defined research scenario

check_scenario <- function(name) {

  s <- research_scenarios[[name]]

  tryCatch({

    # Check all methods, including excluded methods
    filtered <- filter_methods(
      s$answers, include_excluded = TRUE
    )

    available <- filtered$method_id[
      filtered$status != "excluded"
    ]

    # Identify incorrect inclusions and exclusions
    missing <- setdiff(s$expected, available)
    incorrect <- intersect(s$excluded, available)

    # Generate recommendations
    recommendation <- recommend_methods(s$answers)

    top3 <- head(recommendation$candidates$method_id, 3)

    data.frame(
      scenario = name,
      filters_pass = length(missing) == 0 &&
        length(incorrect) == 0,
      expected_missing = paste(missing, collapse = ", "),
      incorrect_inclusions = paste(incorrect, collapse = ", "),
      top3 = paste(top3, collapse = ", "),
      expected_in_top3 = any(s$expected %in% top3),
      recommendation_status = recommendation$status,
      error = ""
    )

  }, error = function(e) {

    data.frame(
      scenario = name,
      filters_pass = FALSE,
      expected_missing = "",
      incorrect_inclusions = "",
      top3 = "",
      expected_in_top3 = FALSE,
      recommendation_status = "ERROR",
      error = conditionMessage(e)
    )
  })
}

# Run all 13 scenarios

qa_results <- do.call(
  rbind,
  lapply(names(research_scenarios), check_scenario)
)

rownames(qa_results) <- NULL

# View complete results
View(qa_results)

# Print scenarios requiring investigation
problems <- subset(
  qa_results,
  !filters_pass | !expected_in_top3 | nzchar(error)
)

cat("\nSCENARIOS REQUIRING REVIEW:\n")
print(problems, row.names = FALSE)

cat("\nSUMMARY:\n")
cat("Scenarios tested:", nrow(qa_results), "\n")
cat("Filter checks passed:", sum(qa_results$filters_pass), "\n")
cat("Expected method in top 3:",
    sum(qa_results$expected_in_top3), "\n")
cat("Execution errors:", sum(nzchar(qa_results$error)), "\n")
