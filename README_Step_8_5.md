# AdamsAnalysis — Step 8.5: R and Python introductory tutorials

This archive adds **73 paired synthetic-data tutorial entries**, each with:
- A learning goal and a description of simulated study data.
- An independent R code example and an independent Python code example.
- Required packages, output to inspect, methodological caveats, and cross-language limitations.

## Install into the AdamsAnalysis project

Extract the archive into the **root** of your existing project, preserving folders.
From that project, run:

```r
source("data-raw/build_method_tutorials.R")
devtools::document()
devtools::load_all()
devtools::test()
View(method_tutorials)
```

The builder creates `data/method_tutorials.rda` and validates IDs and names
against the saved 73-row `data/analysis_catalogue.rda`.

To read the R and Python tutorial for Mixed-Design ANOVA:

```r
m <- subset(method_tutorials, method_id == "AA14")
cat(m$r_code)
cat(m$python_code)
```

Individual runnable demonstrations are provided in `tutorials/R/AA01.R` through
`AA73.R` and `tutorials/python/AA01.py` through `AA73.py`. These are teaching
files **not loaded automatically into the package namespace**. The data object
holds code as text for future display in the Shiny Method Guide; do not execute
untrusted user-provided code from a dashboard.

## Dependencies

R examples use base R or specific optional packages such as afex, lme4,
lavaan, mgcv, survival, glmnet, and dlnm. Python examples use numpy, pandas,
scipy, statsmodels, and scikit-learn, with some additional optional packages,
including pingouin, lifelines, semopy, pygam and factor-analyzer. The two
`*_packages` columns specify requirements per tutorial. **Do not add all
these packages to AdamsAnalysis Imports** merely to display the examples.

## Validation and limitations

- 73/73 method IDs and method names checked against the Step 8.4 reference.
- All 146 Python and R example files generated from the same rows as the CSV.
- Python syntax checks are included in our build QA; R execution and all
  optional Python environments require your local verification.
- Some implementations are analogous rather than identical (especially AA25
  GLMM, AA55 mediation, AA56 latent growth, AA73 DLNM). Differences are
  explicitly marked in `implementation_note`.
- These are **short introductory demonstrations**, not substitutes for
  full methodological teaching or diagnostics in Steps 8.3 and 8.4.
- All datasets are simulated, no participant data or internet required to
  execute after optional dependencies are installed.
- Citations and applied research examples are planned for Step 8.6.
