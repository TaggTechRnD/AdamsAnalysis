#' Generate All Standalone HTML Method Guides
#'
#' Builds the 73 reference pages using generate_method_guide(), plus an
#' index.html page for browsing them. This does not launch or change Shiny.
#'
#' @param output_dir Folder where the HTML pages will be written. From the
#'   AdamsAnalysis project root, the default places them in inst/www/method-guides.
#' @param overwrite Replace existing HTML files (default TRUE).
#' @return Invisibly returns a data frame listing the generated method pages.
#' @export
generate_all_method_guides <- function(
    output_dir = file.path("inst", "www", "method-guides"),
    overwrite = TRUE) {

  if (!is.character(output_dir) || length(output_dir) != 1L ||
      is.na(output_dir) || !nzchar(output_dir)) {
    stop("output_dir must be a nonempty folder path.", call. = FALSE)
  }
  if (!is.logical(overwrite) || length(overwrite) != 1L ||
      is.na(overwrite)) {
    stop("overwrite must be TRUE or FALSE.", call. = FALSE)
  }

  catalogue <- analysis_catalogue
  ids <- as.character(catalogue$method_id)
  names <- as.character(catalogue$method_name)
  if (!length(ids) || anyNA(ids) || anyNA(names) ||
      anyDuplicated(ids) || any(!grepl("^AA[0-9]{2}$", ids))) {
    stop("The method catalogue contains invalid or duplicated IDs.",
         call. = FALSE)
  }

  # Fail before writing pages if any reference dataset is incomplete,
  # duplicated, or associated with a different method name.
  datasets <- list(
    method_guides = method_guides,
    method_mathematics = method_mathematics,
    method_diagnostics = method_diagnostics,
    method_interpretation = method_interpretation,
    method_tutorials = method_tutorials,
    method_references = method_references
  )

  for (dataset_name in base::names(datasets)) {
    d <- datasets[[dataset_name]]
    if (!is.data.frame(d) ||
        !all(c("method_id", "method_name") %in% base::names(d))) {
      stop("Missing method_id/method_name in ", dataset_name, call. = FALSE)
    }
    d_ids <- as.character(d$method_id)
    if (anyNA(d_ids) || anyDuplicated(d_ids) ||
        !setequal(d_ids, ids)) {
      stop("Method ID mismatch in ", dataset_name, call. = FALSE)
    }
    d_names <- as.character(d$method_name[match(ids, d_ids)])
    if (!identical(d_names, names)) {
      stop("Method name mismatch in ", dataset_name, call. = FALSE)
    }
  }

  filenames <- paste0(ids, ".html")
  paths <- file.path(output_dir, filenames)
  index_path <- file.path(output_dir, "index.html")

  if (!overwrite && any(file.exists(c(paths, index_path)))) {
    stop("HTML files already exist; set overwrite = TRUE to regenerate.",
         call. = FALSE)
  }
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  }
  if (!dir.exists(output_dir)) {
    stop("Could not create output folder: ", output_dir, call. = FALSE)
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

  section_labels <- c(
    "Overview and appropriate use", "Mathematical foundation",
    "Assumptions and diagnostics", "Understanding the results",
    "R tutorial", "Python tutorial", "Published research and references"
  )

  bytes <- numeric(length(ids))
  for (i in seq_along(ids)) {
    generate_method_guide(ids[i], file = paths[i], open = FALSE)

    # Validate page identity and the seven required sections, not just
    # that an HTML file happens to exist.
    page <- paste(readLines(paths[i], warn = FALSE, encoding = "UTF-8"),
                  collapse = "\n")
    correct_title <- paste0("<h1>", esc(names[i]), "</h1>")
    if (!grepl(correct_title, page, fixed = TRUE) ||
        !grepl(paste0("ADAMSANALYSIS · ", ids[i]), page, fixed = TRUE) ||
        !all(vapply(section_labels, function(s) {
          grepl(s, page, fixed = TRUE)
        }, logical(1))) ||
        !grepl("</html>", page, fixed = TRUE)) {
      stop("HTML validation failed for ", ids[i], call. = FALSE)
    }
    bytes[i] <- file.info(paths[i])$size
    if (is.na(bytes[i]) || bytes[i] < 1000) {
      stop("Unexpectedly small HTML file for ", ids[i], call. = FALSE)
    }
  }

  # An offline, static entry point for browsing all methods. The links
  # remain relative so they also work when served by Shiny in Step 8.7.3.
  ord <- order(names, ids)
  categories <- as.character(catalogue$category)
  entries <- paste0(
    '<li><a href="', esc(filenames[ord]), '">', esc(names[ord]),
    '</a><span>', esc(ids[ord]), ' · ', esc(categories[ord]), '</span></li>',
    collapse = "\n"
  )
  index_html <- paste0(
    '<!doctype html><html lang="en"><head><meta charset="UTF-8">',
    '<meta name="viewport" content="width=device-width,initial-scale=1">',
    '<title>AdamsAnalysis | Method Library</title>',
    '<style>body{font-family:Segoe UI,Arial,sans-serif;line-height:1.5;',
    'background:#f4f7fb;color:#25344a;margin:0}',
    'main{max-width:900px;margin:35px auto;padding:0 20px}',
    'header{background:#183b63;color:#fff;border-radius:12px;padding:25px}',
    'h1{margin:0}header p{margin:8px 0 0;color:#dae5f0}',
    'ul{padding:0;list-style:none}li{background:#fff;margin:8px 0;',
    'padding:12px 16px;border:1px solid #dfe6ee;border-radius:8px}',
    'a{color:#146ba3;font-weight:600;text-decoration:none}',
    'a:hover{text-decoration:underline}span{display:block;',
    'color:#63748c;font-size:13px}</style></head><body><main>',
    '<header><h1>AdamsAnalysis Method Library</h1><p>', length(ids),
    ' statistical method guides · Standalone HTML reference</p></header>',
    '<ul>', entries, '</ul></main></body></html>'
  )
  writeLines(enc2utf8(index_html), con = index_path, useBytes = TRUE)

  manifest <- data.frame(
    method_id = ids,
    method_name = names,
    file = normalizePath(paths, winslash = "/", mustWork = TRUE),
    bytes = bytes,
    stringsAsFactors = FALSE
  )
  invisible(manifest)
}
