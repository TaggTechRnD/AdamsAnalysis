# AA22 — Binary Logistic Regression
# Goal: Model the probability of a binary outcome through log-odds.
# Packages: numpy, pandas, scipy
# Check: Log-odds coefficients, odds ratios and uncertainty.
# Caveat: Odds ratios are not risk ratios; check separation and calibration.
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

import statsmodels.formula.api as smf
fit=smf.logit("y ~ x + treatment",data=d).fit(disp=False)
print(fit.summary())
print("Odds ratios:\n",np.exp(fit.params))
