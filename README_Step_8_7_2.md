# AdamsAnalysis — Step 8.7.2: Generate and test all 73 HTML guides

**Scope:** Generate static HTML files from the existing six educational datasets.
No changes to the recommendation engine, the Shiny UI, or the existing
`generate_method_guide()` function from Step 8.7.1.

## Add to your project

Copy the two files from this ZIP into the matching project folders:

- `R/generate_all_method_guides.R`
- `tests/testthat/test-generate_all_method_guides.R`

Do **not** replace `R/generate_method_guide.R`; the new function calls it.

## Run from the AdamsAnalysis project root in RStudio

```r
devtools::document()
devtools::load_all()

manifest <- generate_all_method_guides()
stopifnot(nrow(manifest) == 73L)

devtools::test()
```

This writes the **73 guides** to `inst/www/method-guides/AA01.html` through
`inst/www/method-guides/AA73.html` and builds a browseable
`inst/www/method-guides/index.html`.

Open the directory's `index.html` in your web browser to inspect the list
and click any guide. Alternatively, for a direct visual check:

```r
generate_method_guide(
  "AA14", file = "inst/www/method-guides/AA14.html", open = TRUE
)
```

The default destination `inst/www/method-guides/` is intentional: when the
package is installed, the files will be included under `www/method-guides/`.
Step 8.7.3 will connect these pages to Shiny using a local resource path,
with separately considered stable links for downloaded reports.

## QA / completion criteria

- `manifest` contains exactly 73 records with distinct method IDs.
- `index.html` links to all 73 guide pages.
- Every guide contains seven sections and the correct method name/ID.
- Test results show zero failures, and pages AA01, AA14, AA30, AA73 render well.
- Existing `launch_app()` continues to work unchanged.

**Important:** Automated checks verify file generation and structural
consistency, not the scientific accuracy of every tutorial or citation.
Equation enhancement uses online MathJax, as in Step 8.7.1; offline pages
still show the LaTeX source. These files are static and can be regenerated
after updating any educational dataset.

**Version-control note:** Commit both the new R/test files and the generated
`inst/www/method-guides/` folder when local checks pass. No `.rda` dataset is
created by Step 8.7.2.
