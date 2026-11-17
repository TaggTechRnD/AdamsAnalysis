# AA40 — Polynomial Regression
# Goal: Fit quadratic association allowing curvature.
# Packages: numpy, pandas, statsmodels
# Check: Linear and squared coefficients and fitted curve.
# Caveat: Polynomial terms describe shape; extrapolation can be unstable.
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
fit=smf.ols("y ~ x + I(x**2)",data=d).fit()
print(fit.summary())
