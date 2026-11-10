testthat::test_that(
  "Questionnaire responses are interpreted correctly", {

    answers <- list(
      Q01 = "causal",
      Q02 = "continuous",
      Q06 = "two",
      Q07 = "two",
      Q13 = "yes",
      Q14 = "yes",
      Q15 = "unknown"
    )

    x <- AdamsAnalysis::interpret_answers(answers)

    testthat::expect_equal(x$objective, "causal")
    testthat::expect_equal(x$outcome_type, "continuous")
    testthat::expect_true(x$multiple_groups)
    testthat::expect_true(x$multiple_timepoints)
    testthat::expect_equal(x$parallel_trends, "unknown")
    testthat::expect_true(is.na(x$sample_size))
  }
)

testthat::test_that(
  "Unknown information is not treated as false", {

    x <- AdamsAnalysis::interpret_answers(
      list(
        Q01 = "compare",
        Q06 = "unknown",
        Q07 = "unknown"
      )
    )

    testthat::expect_true(is.na(x$multiple_groups))
    testthat::expect_true(is.na(x$multiple_timepoints))
  }
)
