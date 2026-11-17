# AA43 — Ordinal Logistic Regression
# Goal: Model proportional-odds cumulative category probabilities.
# Packages: numpy, pandas, statsmodels
# Check: Common slope odds ratios and estimated thresholds.
# Caveat: Test proportional-odds assumption; slope signs depend on cumulative-odds convention.
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

from statsmodels.miscmodels.ordinal_model import OrderedModel
score=.8*d.x.to_numpy()-.4*d.treatment.to_numpy()+rng.normal(size=len(d))
d["grade"]=np.digitize(score,[-.5,.5])
fit=OrderedModel(d.grade,d[["x","treatment"]],distr="logit").fit(method="bfgs",disp=False)
print(fit.summary())
