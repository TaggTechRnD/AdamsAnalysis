# AA60 — Propensity Score Methods
# Goal: Estimate inverse-probability-weighted treatment difference using measured covariate x.
# Packages: numpy, pandas, statsmodels
# Check: Weighted treatment coefficient, weight range and covariate balance (to check separately).
# Caveat: Truncation, overlap, covariate balance, missing confounders, and variance estimation require care; not automatic causal proof.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng=np.random.default_rng(2026)
n=450
x=rng.normal(size=n)
p_treat=1/(1+np.exp(-(-.2+.9*x)))
treated=rng.binomial(1,p_treat)
y=4+1.6*treated+1.4*x+rng.normal(0,1.2,n)
d=pd.DataFrame({"y":y,"x":x,"treated":treated})

import statsmodels.formula.api as smf
psfit=smf.logit("treated ~ x",data=d).fit(disp=False)
ps=np.clip(psfit.predict(d),.02,.98)
w=np.where(d.treated==1,1/ps,1/(1-ps))
fit=smf.wls("y ~ treated",data=d,weights=w).fit(cov_type="HC1")
print(fit.summary().tables[1])
print(pd.Series(w).describe())
