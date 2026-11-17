# AA48 — Generalized Estimating Equations (GEE)
# Goal: Estimate population-average effects for clustered binary outcomes.
# Packages: numpy, pandas, statsmodels
# Check: Marginal coefficients and robust uncertainty.
# Caveat: GEE requires sufficient independent clusters; working correlation is a modeling choice.
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
from statsmodels.genmod.cov_struct import Exchangeable
d["id"]=np.repeat(np.arange(70),4)
u=rng.normal(size=70)
p=1/(1+np.exp(-(-.3+.7*d.x.to_numpy()+.3*u[d.id.to_numpy()])))
d["y"]=rng.binomial(1,p)
fit=sm.GEE.from_formula("y ~ x + treatment",groups="id",data=d,
                        family=sm.families.Binomial(),cov_struct=Exchangeable()).fit()
print(fit.summary())
