testthat::test_that("method interpretation data matches catalogue", {
  testthat::expect_s3_class(method_interpretation, "data.frame")
  testthat::expect_identical(nrow(method_interpretation), 73L)
  testthat::expect_identical(method_interpretation$method_id,
                             analysis_catalogue$method_id)
  testthat::expect_identical(method_interpretation$method_name,
                             analysis_catalogue$method_name)
  testthat::expect_identical(anyDuplicated(method_interpretation$method_id), 0L)

  expected <- c(
    "method_id", "method_name", "primary_outputs", "inference_and_tests",
    "effect_sizes_and_intervals", "fit_and_performance_metrics",
    "interpretation_guidance", "common_misinterpretations", "reporting_example"
  )
  testthat::expect_identical(names(method_interpretation), expected)
  for (field in expected) {
    testthat::expect_false(anyNA(method_interpretation[[field]]))
    testthat::expect_true(all(nzchar(trimws(method_interpretation[[field]]))))
  }
})

testthat::test_that("important statistical interpretation cautions appear", {
  guide <- function(id, field) {
    method_interpretation[method_interpretation$method_id == id, field]
  }
  testthat::expect_match(guide("AA14", "interpretation_guidance"),
                         "difference.in.change", ignore.case = TRUE)
  testthat::expect_match(guide("AA22", "common_misinterpretations"),
                         "risk ratios", ignore.case = TRUE)
  testthat::expect_match(guide("AA24", "common_misinterpretations"),
                         "REML", ignore.case = TRUE)
  testthat::expect_match(guide("AA30", "common_misinterpretations"),
                         "parallel trends", ignore.case = TRUE)
  testthat::expect_match(guide("AA52", "common_misinterpretations"),
                         "construct validity", ignore.case = TRUE)
  testthat::expect_match(guide("AA60", "common_misinterpretations"),
                         "unmeasured confounding", ignore.case = TRUE)
  testthat::expect_match(guide("AA69", "inference_and_tests"),
                         "no.*p.values", ignore.case = TRUE)
  testthat::expect_match(guide("AA73", "effect_sizes_and_intervals"),
                         "cumulative", ignore.case = TRUE)
})
