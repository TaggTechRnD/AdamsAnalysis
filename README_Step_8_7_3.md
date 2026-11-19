# AdamsAnalysis — Step 8.7.3: Link HTML guides to Shiny and downloadable reports

This integration does NOT replace your existing launch_app(), create_report_html(), statistical engine, or generated HTML guides. Keep your original HTML download button too.

## 1. Copy files

Copy `R/method_guide_links.R` and `tests/testthat/test-method_guide_links.R` into the corresponding project folders.

This step uses the cross-platform CRAN `zip` package **only** for the optional portable ZIP download. Add it as a package dependency once:

```r
usethis::use_package("zip", type = "Imports")
```

## 2. Register static HTML pages in the original Shiny launcher

In `R/launch_app.R`, inside `launch_app <- function(...) { ... }`, add the following near the beginning, BEFORE constructing or running the Shiny app:

```r
register_method_guides()
```

That makes `inst/www/method-guides/AA14.html` available to a browser at `method-guides/AA14.html` while Shiny is running. The helper resolves either a local development project or an installed AdamsAnalysis package. All guides must already have been generated at Step 8.7.2.

## 3. Add links to the existing Shiny UI

In an appropriate location in the existing dashboard UI (for example, the header), add:

```r
shiny::tags$a("Browse All Methods",
              href = "method-guides/index.html",
              target = "_blank", rel = "noopener noreferrer")
```

Inside the existing `output$recommendation_ui <- shiny::renderUI({ ... })`, in the primary recommendation display, use this link **in place of** the existing plain method-name text:

```r
method_guide_link(r$primary$method_id[1], r$primary$method_name[1])
```

Inside the existing `lapply(..., function(i) { ... })` that displays alternatives, replace only the alternative's method-name text with:

```r
method_guide_link(r$alternatives$method_id[i], r$alternatives$method_name[i])
```

Do not move or replace any reactivity, test logic, or other UI content. These links are ordinary anchor tags, so they do not create Shiny sessions.

## 4. Download a portable report WITH working guide links

A standalone downloaded HTML file with `method-guides/AA14.html` links is NOT portable on its own. The following second download button produces a ZIP containing `AdamsAnalysis_Report.html`, all 73 HTML guides, and the index, preserving links between them after extracting the ZIP.

In the same UI region as your existing download button, add:

```r
shiny::downloadButton("download_report_bundle", "Download Report + Guides (ZIP)")
```

Inside your existing Shiny server function, add:

```r
output$download_report_bundle <- shiny::downloadHandler(
  filename = function() paste0("AdamsAnalysis_", Sys.Date(), "_Guides.zip"),
  content = function(file) {
    create_method_report_bundle(answers(), recommendation(), file)
  },
  contentType = "application/zip"
)
```

This assumes the existing app uses the previously established `answers()` and `recommendation()` reactive names and that `create_report_html(answers, result)` returns the existing report string. If your local code differs, adjust the names accordingly. **The original HTML report download remains unchanged**; the portable ZIP is the new linked-report option.

## 5. Test one thing at a time

```r
devtools::document()
devtools::load_all()
devtools::test()
launch_app()
```

- Click **Browse All Methods**; verify the library opens in a NEW browser tab.
- Select a randomized repeated-measures example; click the primary method's guide link and an alternative's guide link; verify correct method IDs.
- Download the ZIP. Extract it to any folder and open `AdamsAnalysis_Report.html` *with Shiny closed*; verify the recommended-method links and the `Browse all 73 guides` link still work.
- Re-run `devtools::test()` and check the existing HTML report button still works.

**Known limitations:** Downloaded single-file reports won't have portable guide links; use the ZIP. The generated pages optionally use online MathJax for typeset equations; without internet the LaTeX source is still available. We were not given your current `launch_app.R` or `create_report_html.R` source files in this conversation, so the UI insertion points are based on the implementation described earlier, not an exact line-by-line patch.
