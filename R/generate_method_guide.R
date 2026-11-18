#' Generate a Standalone HTML Method Guide
#'
#' Creates an HTML reference guide from the six existing educational datasets.
#' The file can be opened in a browser without running Shiny.
#'
#' @param method_id Method identifier, e.g. "AA14".
#' @param file Destination HTML path; defaults to a temporary file.
#' @param open Open the HTML file in the default browser after writing.
#' @return Invisibly returns the absolute path of the HTML file.
#' @export
generate_method_guide <- function(
    method_id = "AA14",
    file = tempfile(pattern = paste0("AdamsAnalysis_", method_id, "_"),
                    fileext = ".html"),
    open = interactive()) {

  if (!is.character(method_id) || length(method_id) != 1L ||
      is.na(method_id) || !grepl("^AA[0-9]{2}$", method_id)) {
    stop("method_id must be an identifier such as 'AA14'.", call. = FALSE)
  }
  if (!is.character(file) || length(file) != 1L || is.na(file) || !nzchar(file)) {
    stop("file must be a nonempty filename.", call. = FALSE)
  }

  # Datasets are installed with AdamsAnalysis and share the same method_id.
  get_record <- function(data, id) {
    idx <- which(data$method_id == id)
    if (length(idx) != 1L) {
      stop("Missing or duplicated method_id in reference data: ", id,
           call. = FALSE)
    }
    data[idx, , drop = FALSE]
  }

  guide <- get_record(method_guides, method_id)
  math <- get_record(method_mathematics, method_id)
  diagnostics <- get_record(method_diagnostics, method_id)
  interpretation <- get_record(method_interpretation, method_id)
  tutorials <- get_record(method_tutorials, method_id)
  references <- get_record(method_references, method_id)

  # Escape both content and attribute values before writing HTML.
  esc <- function(x) {
    if (length(x) == 0L || is.na(x[1L])) return("")
    x <- as.character(x[1L])
    x <- gsub("&", "&amp;", x, fixed = TRUE)
    x <- gsub("<", "&lt;", x, fixed = TRUE)
    x <- gsub(">", "&gt;", x, fixed = TRUE)
    x <- gsub('"', "&quot;", x, fixed = TRUE)
    x <- gsub("'", "&#39;", x, fixed = TRUE)
    x
  }
  has_text <- function(x) length(x) > 0L && !is.na(x[1L]) &&
    nzchar(trimws(as.character(x[1L])))
  field <- function(label, value) {
    if (!has_text(value)) return("")
    paste0('<div class="field"><h4>', esc(label), '</h4><p>',
           esc(value), '</p></div>')
  }
  code_field <- function(label, value, language) {
    if (!has_text(value)) return("")
    paste0('<div class="field"><h4>', esc(label), '</h4><pre><code class="',
           esc(language), '">', esc(value), '</code></pre></div>')
  }
  link <- function(url, label) {
    if (!has_text(url) || !grepl("^https?://", url[1L])) return("")
    paste0('<a target="_blank" rel="noopener noreferrer" href="',
           esc(url), '">', esc(label), '</a>')
  }
  section <- function(title, contents, expanded = FALSE) {
    paste0('<details', if (expanded) ' open' else '', '><summary>',
           esc(title), '</summary><div class="details-body">',
           contents, '</div></details>')
  }

  overview <- paste0(
    field("Purpose", guide$purpose),
    field("Example research questions", guide$research_questions),
    field("Design requirements", guide$design_requirements),
    field("Strengths", guide$strengths),
    field("Limitations", guide$limitations),
    field("When not to use it", guide$inappropriate_use),
    field("Illustrative research scenario (hypothetical)", guide$research_example)
  )
  equations <- paste0(
    field("Mathematical foundation", math$foundation_type),
    if (has_text(math$equation_latex)) {
      paste0('<div class="equation">\\(', esc(math$equation_latex), '\\)</div>',
             '<details class="equation-source"><summary>View LaTeX source</summary>',
             '<pre>', esc(math$equation_latex), '</pre></details>')
    } else "",
    field("Symbols", math$symbol_definitions),
    field("Explanation", math$mathematical_explanation),
    field("Important scope limitation", math$scope_note)
  )
  checks <- paste0(
    field("Assumptions and conditions", diagnostics$assumptions_and_conditions),
    field("Diagnostics to perform", diagnostics$diagnostic_procedures),
    field("Consequences of violations", diagnostics$if_violated),
    field("Diagnostic caveats", diagnostics$diagnostic_caveats)
  )
  results <- paste0(
    field("Primary outputs", interpretation$primary_outputs),
    field("Inference and tests", interpretation$inference_and_tests),
    field("Effect sizes and intervals", interpretation$effect_sizes_and_intervals),
    field("Model fit and performance", interpretation$fit_and_performance_metrics),
    field("Interpreting results", interpretation$interpretation_guidance),
    field("Common mistakes", interpretation$common_misinterpretations),
    field("Example report wording (placeholder values)", interpretation$reporting_example)
  )
  r_tutorial <- paste0(
    field("Learning goal", tutorials$learning_goal),
    field("Simulated data", tutorials$study_data),
    field("Packages", tutorials$r_packages),
    code_field("R example", tutorials$r_code, "language-r"),
    field("Output to inspect", tutorials$output_to_inspect),
    field("Limitations and checks", tutorials$limitations_and_checks)
  )
  python_tutorial <- paste0(
    field("Learning goal", tutorials$learning_goal),
    field("Simulated data", tutorials$study_data),
    field("Packages", tutorials$python_packages),
    code_field("Python example", tutorials$python_code, "language-python"),
    field("Implementation notes", tutorials$implementation_note),
    field("Output to inspect", tutorials$output_to_inspect)
  )

  applied_status <- as.character(references$applied_status[1L])
  applied_heading <- if (identical(applied_status, "verified_method_application")) {
    "Verified published application"
  } else {
    "Applied study / methodological illustration (review status shown)"
  }
  reference_body <- paste0(
    field("Methodological source", references$methodological_citation),
    link(references$methodological_url, "Open methodological reference"),
    field("Reference type", references$methodological_reference_type),
    field(applied_heading, references$applied_citation),
    link(references$applied_url, "Open cited study"),
    field("Application context", references$applied_context),
    field("Applied-reference review status", references$applied_status),
    field("Bibliographic caveat", references$review_note),
    if (!has_text(references$applied_citation)) {
      '<p class="note">No verified applied study is available yet.</p>'
    } else ""
  )

  css <- paste0(
    'body{margin:0;background:#f4f7fb;color:#25344a;',
    'font-family:Segoe UI,Arial,sans-serif;line-height:1.55}',
    '.container{max-width:930px;margin:30px auto;padding:0 18px 40px}',
    '.hero{background:#183b63;color:white;border-radius:12px;',
    'padding:26px 30px;margin-bottom:16px}',
    '.hero h1{color:white;margin:4px 0;font-size:30px}',
    '.hero p{margin:0;color:#cbd9eb}',
    '.id{font-size:12px;font-weight:700;letter-spacing:1.5px}',
    'details{background:white;border:1px solid #dfe6ee;border-radius:9px;',
    'margin-bottom:11px;overflow:hidden}',
    'summary{cursor:pointer;padding:16px 20px;font-size:18px;',
    'font-weight:650;color:#183b63}',
    'details[open]>summary{border-bottom:1px solid #e8edf4}',
    '.details-body{padding:10px 20px 20px}',
    '.field{margin:12px 0 17px}.field h4{margin:0 0 4px;font-size:14px;',
    'color:#2878a8}.field p{margin:0;white-space:pre-wrap}',
    'pre{white-space:pre;overflow-x:auto;background:#f0f4f8;',
    'border:1px solid #dfe6ef;border-radius:7px;padding:14px;',
    'font-size:13px;line-height:1.5}',
    '.equation{background:#f0f4f8;border-radius:7px;padding:20px;',
    'overflow-x:auto;text-align:center;font-size:19px}',
    '.equation-source{margin-top:10px}.equation-source summary{font-size:13px}',
    'a{color:#146ba3}.note{color:#64748b;font-style:italic}',
    'footer{color:#63748c;font-size:13px;margin-top:22px}',
    '@media print{body{background:white}.container{max-width:none}',
    'details{break-inside:avoid}summary{color:black}}'
  )

  html <- paste0(
    '<!doctype html><html lang="en"><head><meta charset="UTF-8">',
    '<meta name="viewport" content="width=device-width,initial-scale=1">',
    '<title>', esc(guide$method_name), ' | AdamsAnalysis</title>',
    '<style>', css, '</style>',
    # Optional online mathematics typesetting. All text and code works offline.
    '<script defer src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>',
    '</head><body><main class="container">',
    '<header class="hero"><div class="id">ADAMSANALYSIS · ', esc(method_id),
    '</div><h1>', esc(guide$method_name), '</h1>',
    '<p>Statistical method reference guide</p></header>',
    section("Overview and appropriate use", overview, expanded = TRUE),
    section("Mathematical foundation", equations),
    section("Assumptions and diagnostics", checks),
    section("Understanding the results", results),
    section("R tutorial", r_tutorial),
    section("Python tutorial", python_tutorial),
    section("Published research and references", reference_body),
    '<footer>Educational reference only. Verify assumptions and statistical ',
    'claims before applying a method to real research. ',
    'The equation is typeset by MathJax when internet access is available; ',
    'its LaTeX source remains available offline.</footer>',
    '</main></body></html>'
  )

  dir_path <- dirname(file)
  if (!dir.exists(dir_path)) {
    stop("Destination folder does not exist: ", dir_path, call. = FALSE)
  }
  writeLines(enc2utf8(html), con = file, useBytes = TRUE)
  path <- normalizePath(file, winslash = "/", mustWork = TRUE)

  if (isTRUE(open)) {
    url <- if (grepl("^[A-Za-z]:/", path)) paste0("file:///", path) else
      paste0("file://", path)
    utils::browseURL(url)
  }
  invisible(path)
}
