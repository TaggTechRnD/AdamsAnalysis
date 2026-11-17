testthat::test_that("mathematical guides match the analysis catalogue", {
  testthat::expect_s3_class(method_mathematics, "data.frame")
  testthat::expect_equal(nrow(method_mathematics), 73L)
  testthat::expect_identical(method_mathematics$method_id, analysis_catalogue$method_id)
  testthat::expect_identical(method_mathematics$method_name, analysis_catalogue$method_name)
  testthat::expect_equal(anyDuplicated(method_mathematics$method_id), 0L)

  fields <- c("foundation_type", "equation_latex", "symbol_definitions",
              "mathematical_explanation", "scope_note")
  testthat::expect_true(all(fields %in% names(method_mathematics)))
  for (field in fields) {
    testthat::expect_false(anyNA(method_mathematics[[field]]))
    testthat::expect_true(all(nzchar(trimws(method_mathematics[[field]]))))
  }
})

testthat::test_that("critical mathematical examples are included", {
  for (id in c("AA14", "AA24", "AA30", "AA58", "AA73")) {
    row <- method_mathematics[method_mathematics$method_id == id, ]
    testthat::expect_equal(nrow(row), 1L)
    testthat::expect_true(nzchar(row$equation_latex))
    testthat::expect_true(nzchar(row$scope_note))
  }
})
