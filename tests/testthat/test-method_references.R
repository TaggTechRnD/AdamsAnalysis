testthat::test_that("method references align exactly to 73 catalogue methods", {
  testthat::expect_s3_class(method_references, "data.frame")
  testthat::expect_identical(nrow(method_references), 73L)
  testthat::expect_identical(method_references$method_id,
                             analysis_catalogue$method_id)
  testthat::expect_identical(method_references$method_name,
                             analysis_catalogue$method_name)
  testthat::expect_identical(anyDuplicated(method_references$method_id), 0L)
  testthat::expect_identical(ncol(method_references), 10L)
  testthat::expect_false(anyNA(method_references))
  testthat::expect_true(all(nzchar(trimws(method_references$methodological_citation))))
  testthat::expect_true(all(grepl("^https://", method_references$methodological_url)))
})

testthat::test_that("applied examples have honest completeness flags", {
  x <- method_references
  pending <- x$applied_status == "pending_applied_study"
  testthat::expect_true(all(x$applied_citation[pending] == ""))
  testthat::expect_true(all(x$applied_url[pending] == ""))
  testthat::expect_true(all(x$applied_citation[!pending] != ""))
  testthat::expect_true(all(grepl("^https://", x$applied_url[!pending])))
  testthat::expect_identical(x$applied_status[x$method_id == "AA30"],
                             "verified_method_application")
  testthat::expect_identical(x$applied_status[x$method_id == "AA73"],
                             "verified_method_application")
  testthat::expect_identical(x$applied_status[x$method_id == "AA50"],
                             "requires_full_text_method_check")
})
