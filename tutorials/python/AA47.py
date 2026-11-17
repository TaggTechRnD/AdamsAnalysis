# AA47 — Quantile Regression
# Goal: Estimate conditional median shifts instead of mean shifts.
# Packages: numpy, pandas, statsmodels
# Check: Median regression coefficients at tau=0.5.
# Caveat: Conditional quantile coefficients are not changes in unconditional population medians.
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
fit=smf.quantreg("y ~ x + C(group)",data=d).fit(q=.5)
print(fit.summary())
