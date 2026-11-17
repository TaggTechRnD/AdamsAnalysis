# AA31 — Cross-Tabulation
# Goal: Produce cross-tabulations and within-group proportions.
# Packages: numpy, pandas, scipy
# Check: Cell counts, margins, and denominator-aware percentages.
# Caveat: A crosstab is descriptive; no causal inference is justified.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 280
x = rng.normal(size=n)
treatment = rng.binomial(1, .5, n)
p = 1 / (1 + np.exp(-(-.5 + .8*x - .7*treatment)))
y = rng.binomial(1, p)
d = pd.DataFrame({"y": y,"x": x,"treatment":treatment})

ct=pd.crosstab(d.treatment,d.y,margins=True)
print(ct)
print(pd.crosstab(d.treatment,d.y,normalize="index"))
