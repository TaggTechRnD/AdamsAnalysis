# AA35 — Partial Correlation
# Goal: Estimate the linear x–y correlation after adjusting for group.
# Packages: numpy, pandas, scipy, statsmodels
# Check: Partial correlation coefficient; note residualization.
# Caveat: For formal inference accounting for control variables, adjust degrees of freedom (naive residual correlation p-value does not).
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
from scipy import stats
rx=smf.ols("x ~ C(group)",data=d).fit().resid
ry=smf.ols("y ~ C(group)",data=d).fit().resid
r=np.corrcoef(rx,ry)[0,1]
df=len(rx)-3
stat=r*np.sqrt(df/(1-r**2))
print({"partial_r":r,"df":df,"p_value":2*stats.t.sf(abs(stat),df)})
