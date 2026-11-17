# AA18 — Chi-Square Test of Independence
# Goal: Evaluate association between two categorical variables.
# Packages: numpy, pandas, scipy
# Check: Observed/expected counts and Pearson chi-square test.
# Caveat: Review expected counts; chi-square does not quantify effect magnitude.
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
ct=pd.crosstab(d.treatment,d.y)
print(ct)
print(stats.chi2_contingency(ct))
