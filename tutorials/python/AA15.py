# AA15 — ANCOVA
# Goal: Compare group means while adjusting for a continuous baseline covariate.
# Packages: numpy, pandas, scipy
# Check: Adjusted group coefficient and CI.
# Caveat: Check slope homogeneity by considering a group×covariate term; adjustment alone does not remove confounding.
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
fit=smf.ols("y ~ C(group) + x",data=d).fit()
print(fit.summary())
