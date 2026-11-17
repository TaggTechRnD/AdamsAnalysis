testthat::test_that("Tutorials cover the catalogue and have complete fields", {
  testthat::expect_s3_class(method_tutorials, "data.frame")
  testthat::expect_identical(nrow(method_tutorials), 73L)
  testthat::expect_identical(method_tutorials$method_id,
                             analysis_catalogue$method_id)
  testthat::expect_identical(method_tutorials$method_name,
                             analysis_catalogue$method_name)
  testthat::expect_identical(anyDuplicated(method_tutorials$method_id), 0L)
  testthat::expect_identical(ncol(method_tutorials), 11L)
  for (column in method_tutorials) {
    testthat::expect_false(anyNA(column))
    testthat::expect_true(all(nzchar(trimws(column))))
  }
})

testthat::test_that("Every example uses simulated reproducible data", {
  testthat::expect_true(all(grepl("set.seed", method_tutorials$r_code,
                                 fixed=TRUE)))
  testthat::expect_true(all(grepl("default_rng", method_tutorials$python_code,
                                 fixed=TRUE)))
  testthat::expect_false(any(grepl("read.csv\\(|read_excel\\(|read_spss\\(",
                                   method_tutorials$r_code)))
  testthat::expect_false(any(grepl("read_csv\\(|read_excel\\(",
                                   method_tutorials$python_code)))
})

testthat::test_that("Critical methods have explicit warnings and implementations", {
  entry <- function(id, field) method_tutorials[method_tutorials$method_id==id, field]
  testthat::expect_match(entry("AA14","r_code"), "aov_ez")
  testthat::expect_match(entry("AA14","python_code"), "mixed_anova")
  testthat::expect_match(entry("AA30","r_code"), "vcovCL")
  testthat::expect_match(entry("AA30","limitations_and_checks"), "parallel trends")
  testthat::expect_match(entry("AA25","implementation_note"), "Bayesian")
  testthat::expect_match(entry("AA73","implementation_note"), "not a direct DLNM")
})

testthat::test_that("All R tutorial scripts parse", {
  for (i in seq_len(nrow(method_tutorials))) {
    testthat::expect_error(parse(text=method_tutorials$r_code[i]), NA,
                           info=method_tutorials$method_id[i])
  }
})
