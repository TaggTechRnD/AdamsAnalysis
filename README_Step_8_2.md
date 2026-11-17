# AdamsAnalysis — Step 8.2: Mathematical foundations

This adds `method_mathematics`, a separate, non-executable educational dataset with 73 entries and seven fields.
It does not alter filtering, ranking, recommendations, Shiny, or `method_guides`.

1. Extract these files into the ROOT of the AdamsAnalysis package, preserving subfolders.
2. In the package project, run:

```r
source("data-raw/build_method_mathematics.R")
devtools::document()
devtools::load_all()
devtools::test()
View(method_mathematics)
```

The object is saved as `data/method_mathematics.rda` and joins with `analysis_catalogue` and `method_guides` by `method_id`.

## Editorial status
These are representative mathematical foundations, not complete mathematical derivations or implementation-ready algorithms. Complex method families (e.g. ETS, random forests, SEM, GLMMs, hierarchical clustering) deliberately illustrate one common formulation; the `scope_note` identifies important omissions or variants.

Step 8.3 adds detailed assumptions and diagnostics; Step 8.4 addresses results and interpretation; methodology citations are scheduled for Step 8.6. Statistical and mathematical review remains necessary prior to public release.
