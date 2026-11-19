testthat::test_that("guide links target the correct static HTML pages", {
  link <- as.character(method_guide_link("AA14"))
  testthat::expect_match(link, 'href="method-guides/AA14.html"', fixed = TRUE)
  testthat::expect_match(link, 'target="_blank"', fixed = TRUE)
  testthat::expect_match(link, "Mixed-Design ANOVA", fixed = TRUE)
  testthat::expect_error(method_guide_link("AA99"), "Unknown method ID")
})

testthat::test_that("the generated HTML guide directory is complete", {
  path <- method_guide_directory()
  testthat::expect_true(file.exists(file.path(path, "index.html")))
  testthat::expect_true(all(file.exists(file.path(
    path, paste0(analysis_catalogue$method_id, ".html")
  ))))
})

testthat::test_that("the portable report contains the report and guides", {
  testthat::skip_if_not_installed("zip")
  answers <- list(Q01 = "compare", Q02 = "continuous", Q06 = "two",
                  Q07 = "two", Q08 = "repeated", Q09 = "randomized")
  result <- recommend_methods(answers)
  file <- tempfile(fileext = ".zip")
  on.exit(unlink(file), add = TRUE)
  create_method_report_bundle(answers, result, file)
  contents <- utils::unzip(file, list = TRUE)$Name
  testthat::expect_true("AdamsAnalysis_Report.html" %in% contents)
  testthat::expect_true("method-guides/index.html" %in% contents)
  testthat::expect_true("method-guides/AA14.html" %in% contents)
})
