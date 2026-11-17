# AA55 — Mediation Analysis
# Goal: Estimate a proposed indirect pathway through mediator m.
# Packages: numpy, pandas, statsmodels
# Check: Estimated indirect effect and sensitivity to assumptions.
# Caveat: Mediation identification needs strong treatment–mediator and mediator–outcome confounding assumptions; Python uses a simpler product estimator.
# Implementation note: analog: mediation estimator versus simple bootstrap product

import numpy as np
import pandas as pd
rng=np.random.default_rng(2026)
n=450
x=rng.normal(size=n)
p_treat=1/(1+np.exp(-(-.2+.9*x)))
treated=rng.binomial(1,p_treat)
y=4+1.6*treated+1.4*x+rng.normal(0,1.2,n)
d=pd.DataFrame({"y":y,"x":x,"treated":treated})

# Simple bootstrap of product-of-coefficients; not identical to mediation::mediate
import statsmodels.formula.api as smf
d["m"] = .8*d.treated+.5*d.x+rng.normal(size=len(d))
d["y"] = .5*d.treated+.6*d.m+.5*d.x+rng.normal(size=len(d))
a=smf.ols("m ~ treated + x",data=d).fit().params["treated"]
b=smf.ols("y ~ treated + m + x",data=d).fit().params["m"]
boot=[]
for k in range(200):
    sample=d.iloc[rng.integers(0,len(d),len(d))]
    aa=smf.ols("m ~ treated + x",data=sample).fit().params["treated"]
    bb=smf.ols("y ~ treated + m + x",data=sample).fit().params["m"]
    boot.append(aa*bb)
print("Indirect product:",a*b,"bootstrap interval:",np.percentile(boot,[2.5,97.5]))
