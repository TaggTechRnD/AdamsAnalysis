testthat::test_that("Randomized 2 by 2 design recommends mixed ANOVA", {
  a <- list(Q01="causal", Q02="continuous", Q03="one", Q04="categorical",
            Q05="one", Q06="two", Q07="two", Q08="repeated",
            Q09="randomized", Q10=88, Q11="yes", Q12="normal",
            Q13="yes", Q14="yes", Q15="yes")

  x <- AdamsAnalysis::recommend_methods(a)
  testthat::expect_equal(x$status, "provisional_recommendation")
  testthat::expect_equal(x$primary$method_id, "AA14")
  testthat::expect_true("AA24" %in% x$alternatives$method_id)
})

testthat::test_that("Quasi experiment prioritizes DiD", {
  a <- list(Q01="causal", Q02="continuous", Q04="categorical",
            Q05="one", Q06="two", Q07="two", Q08="repeated",
            Q09="quasi", Q13="yes", Q14="yes", Q15="unknown")
  x <- AdamsAnalysis::recommend_methods(a)
  testthat::expect_equal(x$primary$method_id, "AA30")
})

testthat::test_that("Zero preference score does not imply missing information", {
  a <- list(Q01="compare", Q02="continuous", Q06="two",
            Q07="one", Q08="independent")
  x <- AdamsAnalysis::recommend_methods(a)
  testthat::expect_false(x$status == "insufficient_information")
  testthat::expect_true(all(c("AA06", "AA07") %in% x$candidates$method_id))
})

testthat::test_that("Implausible parallel trends are flagged and demoted", {
  a <- list(Q01="causal", Q02="continuous", Q06="two",
            Q07="two", Q08="repeated", Q09="quasi",
            Q13="yes", Q14="yes", Q15="no")
  x <- AdamsAnalysis::rank_methods(a)
  did <- x[x$method_id == "AA30", , drop = FALSE]
  testthat::expect_equal(nrow(did), 1L)
  testthat::expect_match(did$assumption_flags, "Parallel trends")
  testthat::expect_lt(did$ranking_score, 0)
})
