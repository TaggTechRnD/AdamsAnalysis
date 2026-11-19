testthat::test_that("all six datasets match the 73-method catalogue", {
  ids <- analysis_catalogue$method_id
  testthat::expect_length(ids, 73L)

  for (d in list(method_guides, method_mathematics, method_diagnostics,
                 method_interpretation, method_tutorials, method_references)) {
    testthat::expect_setequal(d$method_id, ids)
    testthat::expect_false(anyDuplicated(d$method_id) > 0L)
    testthat::expect_identical(
      as.character(d$method_name[match(ids, d$method_id)]),
      as.character(analysis_catalogue$method_name)
    )
  }
})

testthat::test_that("batch generator creates and checks all 73 HTML pages", {
  folder <- tempfile("adams-method-pages-")
  on.exit(unlink(folder, recursive = TRUE), add = TRUE)

  result <- generate_all_method_guides(folder)
  testthat::expect_equal(nrow(result), 73L)
  testthat::expect_setequal(
    basename(result$file), paste0(analysis_catalogue$method_id, ".html")
  )
  testthat::expect_true(all(file.exists(result$file)))
  testthat::expect_true(all(result$bytes > 1000))

  index_path <- file.path(folder, "index.html")
  testthat::expect_true(file.exists(index_path))
  index_html <- paste(readLines(index_path, warn = FALSE, encoding = "UTF-8"),
                      collapse = "\n")
  for (id in analysis_catalogue$method_id) {
    testthat::expect_match(index_html, paste0('href="', id, '.html"'),
                           fixed = TRUE)
  }

  # Inspect the first, middle, and last entries, including one of the
  # methods used in the existing AdamsAnalysis QA scenarios.
  for (id in c("AA01", "AA14", "AA30", "AA73")) {
    page <- paste(readLines(file.path(folder, paste0(id, ".html")),
                            warn = FALSE, encoding = "UTF-8"), collapse = "\n")
    for (heading in c("Overview and appropriate use", "Mathematical foundation",
                      "Assumptions and diagnostics", "Understanding the results",
                      "R tutorial", "Python tutorial",
                      "Published research and references")) {
      testthat::expect_match(page, heading, fixed = TRUE)
    }
  }

  testthat::expect_error(
    generate_all_method_guides(folder, overwrite = FALSE),
    "already exist"
  )
})
