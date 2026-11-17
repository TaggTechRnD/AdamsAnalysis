# AA19 — Fisher's Exact Test
# Goal: Test association in a two-by-two categorical table.
# Packages: numpy, pandas, scipy
# Check: Odds ratio and exact p-value.
# Caveat: For 2×2 tables; an odds ratio is not the same as a risk ratio.
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

from scipy import stats
ct=pd.crosstab(d.treatment,d.y).to_numpy()
print(stats.fisher_exact(ct))
