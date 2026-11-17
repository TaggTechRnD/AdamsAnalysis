# AA30 — Difference-in-Differences (DiD)
# Goal: Estimate treated-minus-control difference in pre/post changes.
# Packages: numpy, pandas, statsmodels
# Check: Coefficient on treated:post and cluster-robust uncertainty.
# Caveat: Two observed periods cannot test pre-treatment parallel trends; this illustration ASSUMES parallel trends.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng=np.random.default_rng(2026)
n=160
d=pd.MultiIndex.from_product([range(n),[0,1]],names=["id","post"]).to_frame(index=False)
d["treated"]=(d.id>=n//2).astype(int)
individual=rng.normal(0,2,n)
d["y"]=10+individual[d.id.to_numpy()]+1.5*d.post+2*d.treated*d.post+rng.normal(size=len(d))

import statsmodels.formula.api as smf
fit=smf.ols("y ~ treated*post",data=d).fit(
    cov_type="cluster",cov_kwds={"groups":d.id})
print(fit.summary().tables[1])
