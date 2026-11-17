testthat::test_that("method diagnostics cover and match the catalogue", {
  testthat::expect_s3_class(method_diagnostics, "data.frame")
  testthat::expect_equal(nrow(method_diagnostics), 73L)
  testthat::expect_identical(method_diagnostics$method_id,
                             analysis_catalogue$method_id)
  testthat::expect_identical(method_diagnostics$method_name,
                             analysis_catalogue$method_name)
  testthat::expect_identical(method_diagnostics$catalogue_assumption_checks,
                             analysis_catalogue$assumption_checks)
  testthat::expect_equal(anyDuplicated(method_diagnostics$method_id), 0L)

  fields <- c("assumptions_and_conditions", "diagnostic_procedures",
              "if_violated", "diagnostic_caveats")
  for (field in fields) {
    testthat::expect_false(anyNA(method_diagnostics[[field]]))
    testthat::expect_true(all(nzchar(trimws(method_diagnostics[[field]]))))
  }
})

testthat::test_that("critical diagnostic cautions are documented", {
  guide <- function(id, field) {
    method_diagnostics[method_diagnostics$method_id == id, field]
  }
  testthat::expect_match(guide("AA14", "diagnostic_caveats"),
                         "two timepoints", ignore.case = TRUE)
  testthat::expect_match(guide("AA30", "diagnostic_caveats"),
                         "only one pre-intervention period", ignore.case = TRUE)
  testthat::expect_match(guide("AA49", "diagnostic_procedures"),
                         "Schoenfeld", ignore.case = TRUE)
  testthat::expect_match(guide("AA60", "diagnostic_caveats"),
                         "unmeasured confounding", ignore.case = TRUE)
  testthat::expect_match(guide("AA73", "diagnostic_procedures"),
                         "lag", ignore.case = TRUE)
})
