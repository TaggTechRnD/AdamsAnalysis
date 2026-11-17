# AA44 — Negative Binomial Regression
# Goal: Model overdispersed event counts.
# Packages: numpy, pandas, statsmodels
# Check: Log count ratio, dispersion parameter and model uncertainty.
# Caveat: Compare with Poisson dispersion; NB models do not automatically handle excess structural zeros.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 300
x = rng.normal(size=n)
mu = np.exp(.4 + .55*x)
y = rng.negative_binomial(1.2, 1.2/(1.2+mu))
d = pd.DataFrame({"y":y,"x":x})

import statsmodels.formula.api as smf
fit=smf.negativebinomial("y ~ x",data=d).fit(disp=False)
print(fit.summary())
