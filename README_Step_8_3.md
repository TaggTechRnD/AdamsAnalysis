# AdamsAnalysis Step 8.3 — Statistical assumptions and diagnostics

This package adds a standalone **draft educational reference** dataset named
`method_diagnostics`, covering all 73 catalogue methods.

## Files

- `data-raw/method_diagnostics.csv` — 73-row content dataset
- `data-raw/build_method_diagnostics.R` — imports, checks and saves `data/method_diagnostics.rda`
- `R/method_diagnostics.R` — package dataset documentation, without unresolved cross-links
- `tests/testthat/test-method_diagnostics.R` — ID, tag and content checks

## Add to AdamsAnalysis

Extract the ZIP at the project root, retaining folder names. In the project R console run:

```r
source("data-raw/build_method_diagnostics.R")
devtools::document()
devtools::load_all()
devtools::test()

file.exists("data/method_diagnostics.rda")
View(method_diagnostics)
```

`method_diagnostics` is saved only after running the build script. Include
`data/method_diagnostics.rda` in the next commit.

## Interpretation and limits

- `catalogue_assumption_checks` reproduces existing metadata tags exactly, so
  alignment with `analysis_catalogue` can be verified.
- The prose is **draft guidance, not an automated diagnostic of user data**.
- Distinguish assumptions that can be investigated empirically from causal or
  sampling assumptions that cannot be verified by a single significance test.
- Non-normality is not itself a flaw in descriptive statistics or every model.
- The release does not modify the recommendation engine, Shiny app, or the
  existing metadata.
- QA tests check presence and consistency, **not full statistical correctness**.
  Methodological review and references remain pending for Step 8.6.
