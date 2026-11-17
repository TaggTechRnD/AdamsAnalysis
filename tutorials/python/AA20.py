# AA20 — Simple Linear Regression
# Goal: Estimate a linear slope relating x to continuous y.
# Packages: numpy, pandas, scipy
# Check: Regression slope, CI and R-squared.
# Caveat: Review residual assumptions; slope does not imply a causal relationship.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 160
x = rng.normal(size=n)
group = np.repeat(["Control", "Treatment"], n // 2)
y = 10 + 1.3 * (group == "Treatment") + 0.9 * x + rng.normal(scale=2, size=n)
d = pd.DataFrame({"y": y, "x": x, "group": group})

import statsmodels.formula.api as smf
fit=smf.ols("y ~ x",data=d).fit()
print(fit.summary())
