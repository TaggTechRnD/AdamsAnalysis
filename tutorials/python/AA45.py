# AA45 — Zero-Inflated Regression
# Goal: Fit distinct processes for zero inflation and positive count intensity.
# Packages: numpy, pandas, statsmodels
# Check: Inflation and count-part coefficients.
# Caveat: Check whether a separate zero-generating process is theoretically justified; optimization can be unstable.
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

from statsmodels.discrete.count_model import ZeroInflatedPoisson
import statsmodels.api as sm
mask=rng.uniform(size=len(d))<.4
d.loc[mask,"y"]=0
X=sm.add_constant(d[["x"]])
fit=ZeroInflatedPoisson(d.y,X,exog_infl=X,inflation="logit").fit(disp=False)
print(fit.summary())
