
testthat::test_that("DLNM is recommended provisionally", {

  answers <- list(
    Q01 = "associate",
    Q02 = "continuous",
    Q04 = "continuous",
    Q05 = "one",
    Q07 = "sequential",
    Q08 = "repeated",
    Q09 = "time_series",
    Q16 = "yes",
    Q17 = "yes"
  )

  x <- AdamsAnalysis::recommend_methods(answers)

  testthat::expect_equal(
    x$status, "provisional_recommendation"
  )

  testthat::expect_equal(
    x$primary$method_id, "AA73"
  )

  testthat::expect_match(
    x$primary$unverified_requirements,
    "defined_lag_window"
  )
})

testthat::test_that("Insufficient answers do not force a choice", {

  x <- AdamsAnalysis::recommend_methods(
    list(Q01 = "compare")
  )

  testthat::expect_equal(
    x$status, "insufficient_information"
  )

  testthat::expect_equal(nrow(x$primary), 0)
  testthat::expect_gt(nrow(x$missing_questions), 0)
})

testthat::test_that("Recommendations exclude rejected methods", {

  x <- AdamsAnalysis::recommend_methods(
    list(
      Q01 = "compare",
      Q02 = "continuous",
      Q06 = "two",
      Q07 = "one",
      Q08 = "independent"
    )
  )

  testthat::expect_false(
    any(x$candidates$status == "excluded")
  )
})

testthat::test_that("Invalid answers are rejected", {

  testthat::expect_error(
    AdamsAnalysis::recommend_methods(
      list(Q01 = "invalid")
    )
  )
})
