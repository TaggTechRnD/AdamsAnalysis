# AA42 — Multinomial Logistic Regression
# Goal: Model an unordered outcome with three categories.
# Packages: numpy, pandas, statsmodels
# Check: Category-specific log-odds relative to reference class.
# Caveat: This simulated construction has ordered categories; use the multinomial estimator as if labels were nominal.
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

import statsmodels.api as sm
score=.8*d.x.to_numpy()-.4*d.treatment.to_numpy()+rng.normal(size=len(d))
d["category"]=np.digitize(score,[-.5,.5])
X=sm.add_constant(d[["x","treatment"]])
fit=sm.MNLogit(d.category,X).fit(disp=False)
print(fit.summary())
