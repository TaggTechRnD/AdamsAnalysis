
testthat::test_that("Hard filters keep compatible group comparisons", {
  answers <- list(Q01="compare", Q02="continuous", Q04="categorical",
                  Q05="one", Q06="two", Q07="one", Q08="independent",
                  Q09="cross_sectional")

  result <- AdamsAnalysis::filter_methods(answers, include_excluded=TRUE)

  testthat::expect_true(result$status[result$method_id == "AA06"] != "excluded")
  testthat::expect_true(result$status[result$method_id == "AA07"] != "excluded")
  testthat::expect_equal(result$status[result$method_id == "AA08"], "excluded")
})

testthat::test_that("DiD uses the translated questionnaire codes", {
  answers <- list(Q01="causal", Q02="continuous", Q04="both",
                  Q05="multiple", Q06="two", Q07="two",
                  Q08="repeated", Q09="quasi", Q13="yes", Q14="yes")

  result <- AdamsAnalysis::filter_methods(answers)

  testthat::expect_true("AA30" %in% result$method_id)
})

testthat::test_that("Unverified lag structure is never assumed satisfied", {
  answers <- list(Q01="associate", Q02="continuous", Q04="continuous",
                  Q05="one", Q07="sequential", Q08="repeated",
                  Q09="time_series", Q16="yes")

  result <- AdamsAnalysis::filter_methods(answers)

  dlnm <- result[result$method_id == "AA73", ]

  testthat::expect_equal(dlnm$status, "needs_review")
  testthat::expect_match(dlnm$unverified_requirements, "defined_lag_window")
})

testthat::test_that("Unknown answers don't automatically eliminate methods", {
  result <- AdamsAnalysis::filter_methods(
    list(Q01="compare"),
    include_excluded=TRUE
  )

  testthat::expect_true(any(result$status == "needs_review"))
  testthat::expect_true(any(result$status != "excluded"))
})
