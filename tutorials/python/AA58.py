# AA58 — Exponential Smoothing (ETS)
# Goal: Model level, trend and additive seasonality using exponential smoothing.
# Packages: numpy, pandas, statsmodels
# Check: Future values, smoothing parameters and out-of-sample errors.
# Caveat: Forecast uncertainty not illustrated; choose additive/multiplicative forms based on data.
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

from statsmodels.tsa.holtwinters import ExponentialSmoothing
fit=ExponentialSmoothing(d.y,trend="add",seasonal="add",seasonal_periods=12).fit()
print(fit.forecast(6))
