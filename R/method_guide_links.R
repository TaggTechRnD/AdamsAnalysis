#' Find the generated HTML method guides
#'
#' @return Absolute path to the folder containing the 73 guides.
#' @keywords internal
method_guide_directory <- function() {
  # In development, prefer the project's freshly generated HTML pages.
  in_project <- FALSE
  if (file.exists("DESCRIPTION")) {
    first_lines <- readLines("DESCRIPTION", warn = FALSE)
    in_project <- any(grepl("^Package:[[:space:]]*AdamsAnalysis[[:space:]]*$",
                            first_lines))
  }
  source_path <- file.path("inst", "www", "method-guides")
  installed_path <- system.file("www", "method-guides",
                                package = "AdamsAnalysis")
  candidates <- c(if (in_project) source_path, installed_path)
  candidates <- candidates[nzchar(candidates)]
  valid <- candidates[dir.exists(candidates) &
                        file.exists(file.path(candidates, "index.html")) &
                        file.exists(file.path(candidates, "AA14.html"))]
  if (!length(valid)) {
    stop("Generated method guides not found. Run generate_all_method_guides() ",
         "from the package project, then reinstall if using an installed package.",
         call. = FALSE)
  }
  normalizePath(valid[1L], winslash = "/", mustWork = TRUE)
}

#' Make the HTML method guides available to Shiny
#'
#' Call once at the start of launch_app(), before running the Shiny app.
#' @return Invisibly returns the method guide directory.
#' @export
register_method_guides <- function() {
  path <- method_guide_directory()
  shiny::addResourcePath("method-guides", path)
  invisible(path)
}

#' Link to a method's standalone HTML guide in Shiny
#'
#' @param method_id A valid AdamsAnalysis method ID, e.g. "AA14".
#' @param label Link text; defaults to the catalogue's method name.
#' @return An HTML anchor tag that opens the guide in a new browser tab.
#' @export
method_guide_link <- function(method_id, label = NULL) {
  if (!is.character(method_id) || length(method_id) != 1L ||
      is.na(method_id)) stop("Provide one method ID.", call. = FALSE)
  i <- match(method_id, analysis_catalogue$method_id)
  if (is.na(i)) stop("Unknown method ID: ", method_id, call. = FALSE)
  if (is.null(label)) label <- analysis_catalogue$method_name[i]
  if (!is.character(label) || length(label) != 1L || is.na(label)) {
    stop("label must be one nonmissing string.", call. = FALSE)
  }
  shiny::tags$a(
    label,
    href = paste0("method-guides/", method_id, ".html"),
    target = "_blank",
    rel = "noopener noreferrer"
  )
}

#' Download a portable HTML research report and all method guides as one ZIP
#'
#' The report's method links are relative to the included `method-guides/`
#' folder and therefore continue to work when the ZIP is extracted offline.
#'
#' @param answers Named questionnaire answers, as used by create_report_html().
#' @param result Output from recommend_methods().
#' @param file Destination ZIP filename (e.g. Shiny's downloadHandler path).
#' @return Invisibly returns the ZIP path.
#' @export
create_method_report_bundle <- function(answers,
                                        result = recommend_methods(answers),
                                        file = tempfile(fileext = ".zip")) {
  if (!requireNamespace("zip", quietly = TRUE)) {
    stop("The 'zip' package is required for portable report downloads.",
         call. = FALSE)
  }
  if (!is.character(file) || length(file) != 1L || is.na(file) ||
      !nzchar(file)) stop("file must be one valid filename.", call. = FALSE)

  guide_dir <- method_guide_directory()
  needed <- c("index.html", paste0(analysis_catalogue$method_id, ".html"))
  if (!all(file.exists(file.path(guide_dir, needed)))) {
    stop("Some generated HTML guides are missing. Re-run ",
         "generate_all_method_guides().", call. = FALSE)
  }

  # Build in a temporary directory, so all links in the report can be relative.
  stage <- tempfile("adams-report-")
  dir.create(stage)
  on.exit(unlink(stage, recursive = TRUE), add = TRUE)
  guide_dest <- file.path(stage, "method-guides")
  dir.create(guide_dest)
  if (!all(file.copy(file.path(guide_dir, needed), guide_dest))) {
    stop("Could not copy HTML guides to the report bundle.", call. = FALSE)
  }

  esc <- function(x) {
    x <- as.character(x)
    x[is.na(x)] <- ""
    x <- gsub("&", "&amp;", x, fixed = TRUE)
    x <- gsub("<", "&lt;", x, fixed = TRUE)
    x <- gsub(">", "&gt;", x, fixed = TRUE)
    x <- gsub('"', "&quot;", x, fixed = TRUE)
    gsub("'", "&#39;", x, fixed = TRUE)
  }

  chosen <- character()
  for (group in c("primary", "alternatives")) {
    d <- result[[group]]
    if (is.data.frame(d) && nrow(d) > 0L && "method_id" %in% names(d)) {
      chosen <- c(chosen, as.character(d$method_id))
    }
  }
  chosen <- unique(chosen[chosen %in% analysis_catalogue$method_id])
  method_items <- if (length(chosen)) {
    paste0(vapply(chosen, function(id) {
      i <- match(id, analysis_catalogue$method_id)
      paste0('<li><a href="method-guides/', id, '.html">',
             esc(analysis_catalogue$method_name[i]), '</a></li>')
    }, character(1)), collapse = "\n")
  } else "<li>No methods recommended yet.</li>"

  addendum <- paste0(
    '<section><h2>Statistical Method Guides</h2>',
    '<p>Open the recommended methods below for equations, assumptions, ',
    'worked R/Python examples and references.</p><ul>', method_items,
    '</ul><p><a href="method-guides/index.html">Browse all 73 guides</a></p>',
    '</section>'
  )
  report <- create_report_html(answers, result)
  if (!is.character(report) || length(report) != 1L ||
      !grepl("</body>", report, fixed = TRUE)) {
    stop("create_report_html() did not return a complete HTML document.",
         call. = FALSE)
  }
  report <- sub("</body>", paste0(addendum, "</body>"), report,
                fixed = TRUE)
  writeLines(enc2utf8(report), file.path(stage, "AdamsAnalysis_Report.html"),
             useBytes = TRUE)

  file <- normalizePath(file, winslash = "/", mustWork = FALSE)
  relative_files <- c("AdamsAnalysis_Report.html",
                      file.path("method-guides", needed))
  zip::zipr(zipfile = file, files = relative_files, root = stage,
            include_directories = FALSE, mode = "mirror")
  if (!file.exists(file)) stop("The report ZIP could not be created.",
                               call. = FALSE)
  invisible(file)
}
