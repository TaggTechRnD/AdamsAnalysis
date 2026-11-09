testthat::test_that("Catalogue structure is valid", {

  x <- AdamsAnalysis::analysis_catalogue

  testthat::expect_s3_class(x, "data.frame")
  testthat::expect_equal(nrow(x), 73)
  testthat::expect_equal(ncol(x), 18)

  testthat::expect_false(anyNA(x))
  testthat::expect_false(anyDuplicated(x$method_id) > 0)
  testthat::expect_false(anyDuplicated(x$method_name) > 0)

  testthat::expect_setequal(
    x$method_id,
    sprintf("AA%02d", 1:73)
  )

  testthat::expect_true(all(vapply(
    x,
    function(col) all(nzchar(trimws(as.character(col)))),
    logical(1)
  )))
})

testthat::test_that("Critical methods are present", {

  x <- AdamsAnalysis::analysis_catalogue

  testthat::expect_equal(
    x$method_name[x$method_id == "AA13"],
    "Repeated-Measures ANOVA"
  )

  testthat::expect_equal(
    x$method_name[x$method_id == "AA30"],
    "Difference-in-Differences (DiD)"
  )

  testthat::expect_equal(
    x$method_name[x$method_id == "AA73"],
    "Distributed Lag Non-Linear Model (DLNM)"
  )
})
