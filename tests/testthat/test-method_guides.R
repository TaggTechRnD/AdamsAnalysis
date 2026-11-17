testthat::test_that("method guides cover the full analysis catalogue", {
  testthat::expect_s3_class(method_guides, "data.frame")
  testthat::expect_equal(nrow(method_guides), 73L)
  testthat::expect_identical(method_guides$method_id, analysis_catalogue$method_id)
  testthat::expect_identical(method_guides$method_name, analysis_catalogue$method_name)
  testthat::expect_false(anyDuplicated(method_guides$method_id) > 0L)

  guide_fields <- c(
    "purpose", "research_questions", "design_requirements", "strengths",
    "limitations", "inappropriate_use", "research_example"
  )
  testthat::expect_true(all(guide_fields %in% names(method_guides)))
  for (field in guide_fields) {
    testthat::expect_false(anyNA(method_guides[[field]]))
    testthat::expect_true(all(nzchar(trimws(method_guides[[field]]))))
  }
})
