# AA73 — Distributed Lag Non-Linear Model (DLNM)
# Goal: Demonstrate a nonlinear temperature association distributed over several lags.
# Packages: numpy, pandas, patsy, statsmodels
# Check: Lagged exposure-basis effects and model fit; in R, inspect cross-predictions in subsequent work.
# Caveat: Python example uses separate lag splines, NOT a smooth lag-axis crossbasis; neither example implements a full confounding-adjusted epidemiological DLNM.
# Implementation note: analog: Python lag-spline approximation, not a direct DLNM equivalent

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

# Python approximation: exposure spline by individual lag, not exact dlnm crossbasis
from patsy import dmatrix
import statsmodels.api as sm
n=len(d)
temp=20+8*np.sin(2*np.pi*d.t.to_numpy()/30)+rng.normal(0,2,n)
lag1=np.r_[np.nan,temp[:-1]]
y=5+.08*(temp-20)**2+.05*(lag1-20)**2+rng.normal(size=n)
L=np.column_stack([np.roll(temp,j) for j in range(4)])[3:]
B=dmatrix("bs(z, df=4, degree=3, include_intercept=False) - 1",
          {"z":L.ravel()},return_type="dataframe").to_numpy()
features=B.reshape(len(L),4,4).reshape(len(L),16)
X=sm.add_constant(np.column_stack([features,d.t.to_numpy()[3:]]))
fit=sm.OLS(y[3:],X).fit()
print("Spline model R-squared:",fit.rsquared)
