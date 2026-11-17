# AA23 — Poisson Regression
# Goal: Model event rates with person-time/exposure offset.
# Packages: numpy, pandas, scipy
# Check: Rate ratio exp(beta) and fit diagnostics.
# Caveat: Assess overdispersion and excess zeros; offset assumes coefficient fixed at one.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 280
x = rng.normal(size=n)
exposure = rng.uniform(.5, 2, n)
mu = np.exp(.5 + .6*x + np.log(exposure))
y = rng.poisson(mu)
d = pd.DataFrame({"y":y,"x":x,"exposure":exposure})

import statsmodels.formula.api as smf
import statsmodels.api as sm
fit=smf.glm("y ~ x",data=d,family=sm.families.Poisson(),
            offset=np.log(d.exposure)).fit()
print(fit.summary())
print("Rate ratios:\n",np.exp(fit.params))
