
testthat::test_that("Ranking preserves exclusions", {

  answers <- list(
    Q01 = "compare",
    Q02 = "continuous",
    Q06 = "two",
    Q07 = "one",
    Q08 = "independent"
  )

  x <- AdamsAnalysis::rank_methods(
    answers, include_excluded = TRUE
  )

  testthat::expect_true(
    all(is.na(x$rank[x$status == "excluded"]))
  )
})

testthat::test_that("DLNM receives relevant preference score", {

  answers <- list(
    Q01 = "associate",
    Q07 = "sequential",
    Q16 = "yes",
    Q17 = "yes"
  )

  x <- AdamsAnalysis::rank_methods(answers)

  dlnm <- x[x$method_id == "AA73", ]

  testthat::expect_true(nrow(dlnm) == 1)
  testthat::expect_gt(dlnm$ranking_score, 0)
})

testthat::test_that("DiD flags implausible parallel trends", {

  answers <- list(
    Q01 = "causal",
    Q06 = "two",
    Q07 = "two",
    Q13 = "yes",
    Q14 = "yes",
    Q15 = "no"
  )

  x <- AdamsAnalysis::rank_methods(answers)

  did <- x[x$method_id == "AA30", ]

  testthat::expect_true(nrow(did) == 1)
  testthat::expect_match(
    did$assumption_flags,
    "Parallel trends"
  )
})
