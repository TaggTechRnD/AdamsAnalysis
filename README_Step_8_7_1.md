# AdamsAnalysis — Step 8.7.1

**Goal:** Test a standalone HTML guide for Mixed-Design ANOVA (AA14) without altering Shiny.

This adds only one exported function and one test. The function draws from the six
existing package datasets: `method_guides`, `method_mathematics`, `method_diagnostics`,
`method_interpretation`, `method_tutorials`, and `method_references`.

1. Copy `R/generate_method_guide.R` and `tests/testthat/test-generate_method_guide.R`
   into the corresponding folders in the AdamsAnalysis package.
2. In the RStudio project, run:

```r
devtools::document()
devtools::load_all()
devtools::test()
generate_method_guide("AA14")
```

The final line opens a local HTML file in your browser. If it does not automatically
open, run:

```r
path <- generate_method_guide("AA14", open = FALSE)
utils::browseURL(path)
```

To save a permanent file for inspection:

```r
generate_method_guide("AA14", file = "AA14_Method_Guide.html")
```

**Checks:** overview; equations; assumptions; results; R/Python source code;
methodological citation; correctly labeled applied-study status.

No statistical code in the tutorials is executed when the guide opens. There is no
new R package dependency. The HTML works offline except for enhanced equation
typesetting, which uses MathJax from a CDN when internet access is available.

**Scope:** Step 8.7.1 only. We have not generated 73 static HTML files, nor added
Shiny links or report links. Those are Steps 8.7.2 and 8.7.3.
