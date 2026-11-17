# AA59 — Interrupted Time Series
# Goal: Model level and slope changes at a known intervention date.
# Packages: numpy, pandas, statsmodels
# Check: Post-intervention level change and change in slope.
# Caveat: A segmented regression alone cannot exclude contemporaneous confounding; serial correlation must be checked.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng=np.random.default_rng(2026)
n=180
t=np.arange(1,n+1)
eps=rng.normal(0,1.5,n)
noise=np.zeros(n)
for j in range(1,n): noise[j]=.5*noise[j-1]+eps[j]
y=20+.04*t+2*np.sin(2*np.pi*t/12)+noise
d=pd.DataFrame({"t":t,"y":y})

import statsmodels.formula.api as smf
d["post"]=(d.t>=100).astype(int)
d["since"]=np.maximum(0,d.t-99)
d["y"]+=2*d.post+.1*d.since
fit=smf.ols("y ~ t + post + since + np.sin(2*np.pi*t/12) + np.cos(2*np.pi*t/12)",data=d).fit(
    cov_type="HAC",cov_kwds={"maxlags":12})
print(fit.summary().tables[1])
