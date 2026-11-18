testthat::test_that("AA14 standalone guide is created from all six reference datasets", {
  file <- tempfile(fileext = ".html")
  path <- generate_method_guide("AA14", file = file, open = FALSE)

  testthat::expect_true(file.exists(path))
  html <- paste(readLines(path, warn = FALSE, encoding = "UTF-8"),
                collapse = "\n")
  testthat::expect_match(html, "Mixed-Design ANOVA", fixed = TRUE)
  testthat::expect_match(html, "Mathematical foundation", fixed = TRUE)
  testthat::expect_match(html, "Assumptions and diagnostics", fixed = TRUE)
  testthat::expect_match(html, "R tutorial", fixed = TRUE)
  testthat::expect_match(html, "Python tutorial", fixed = TRUE)
  testthat::expect_match(html, "Published research and references", fixed = TRUE)
  testthat::expect_match(html, "Gueorguieva", fixed = TRUE)
  testthat::expect_error(generate_method_guide("INVALID", open = FALSE))
})
