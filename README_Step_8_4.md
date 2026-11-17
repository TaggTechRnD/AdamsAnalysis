# AdamsAnalysis — Step 8.4: Interpretation of Statistical Results

**Purpose:** Store educational information about typical results and correct interpretation for each of the existing 73 statistical methods. This is not a change to the recommendation engine or the Shiny interface.

## Included files

- `data-raw/method_interpretation.csv`: 73 draft entries, 9 columns.
- `data-raw/build_method_interpretation.R`: builds and saves the package dataset.
- `R/method_interpretation.R`: roxygen dataset documentation (without unresolved cross-links).
- `tests/testthat/test-method_interpretation.R`: structural and key-caveat tests.

## Installation

Extract into the root of your existing AdamsAnalysis project, preserving folder structure. In R, with the package project as the working directory:

```r
source("data-raw/build_method_interpretation.R")
devtools::document()
devtools::load_all()
devtools::test()

file.exists("data/method_interpretation.rda")
dim(method_interpretation)
View(method_interpretation)
```

Expected dimensions: **73 rows × 9 columns**. The generated file is `data/method_interpretation.rda`, which should be committed alongside the source CSV and other project files.

## Coverage

Each method includes:

1. `primary_outputs`: what analyses produce.
2. `inference_and_tests`: significance testing, or an explicit note when no default p-value exists.
3. `effect_sizes_and_intervals`: effect estimates and uncertainty.
4. `fit_and_performance_metrics`: relevant goodness-of-fit, calibration or validation metrics, or a note where none applies.
5. `interpretation_guidance`: how to understand important results.
6. `common_misinterpretations`: common errors to avoid.
7. `reporting_example`: fill-in-the-blank reporting template.

The methods are aligned by `method_id` and `method_name` to the current catalogue. No citations are claimed; methodological and applied sources belong in Step 8.6.

## QA scope and limitations

Checks guarantee matching IDs/names and nonempty fields, and spot-check selected critical cautions. **They do not validate every statistical statement.** Entries are first-pass educational drafts requiring methodological review before publishing to colleagues. Fit-index interpretation depends on estimator, dataset, design and purpose; template values must come from actual analyses, not the placeholders shown.
