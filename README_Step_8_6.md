# AdamsAnalysis — Step 8.6: methodological and applied references

This is a **carefully flagged draft**, not a claim that 73 different published application studies have been verified.

## Files
- `data-raw/method_references.csv`: 73 rows keyed by `method_id` and `method_name`.
- `data-raw/build_method_references.R`: creates package data.
- `R/method_references.R`: roxygen documentation (uses ordinary text, not unresolved internal links).
- `tests/testthat/test-method_references.R`: alignment and status QA checks.

## Build from your existing AdamsAnalysis project root

```r
source("data-raw/build_method_references.R")
devtools::document()
devtools::load_all()
devtools::test()
View(method_references)
```

After running `source()`, verify `data/method_references.rda` exists.

## Coverage and accuracy
- All 73 methods have a methodological citation and a stable DOI/publisher/institutional URL.
- 11 methods have directly relevant, identified empirical applied-study citations.
- 2 entries have empirical illustrations inside methodological papers.
- 1 entry has a published worked tutorial (not an independent empirical validation).
- 1 entry has a methodological review, not an applied study.
- 1 entry needs a full-text method confirmation before it should be described as a verified application.
- 57 entries have `pending_applied_study` and deliberately empty applied fields.

No fabricated citations are inserted to fill the gaps. A paper applying a method is **not evidence that the method is appropriate or produces a valid causal result**. Bibliographic links were researched, with primary-source and publisher checks for many sources, but **not every reference has received independent specialist line-by-line review**. Check historical attribution and the suitability of each paper to the specific analysis before publishing a public-facing guide.

Recommended future app behavior: display the methodological citation for each method. Display an applied example only if its `applied_status` is `verified_method_application` (or distinguish empirical illustrations as such). For pending examples, show “Applied research example under review” rather than an invented publication.

This dataset changes **no recommendation logic or Shiny code**.
