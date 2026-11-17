# AA57 — ARIMA
# Goal: Fit a seasonal ARIMA model and forecast six periods.
# Packages: numpy, pandas, statsmodels
# Check: Model coefficients, forecast and residual autocorrelation.
# Caveat: Choose order based on diagnostics, not arbitrary default; avoid look-ahead leakage.
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

from statsmodels.tsa.statespace.sarimax import SARIMAX
fit=SARIMAX(d.y,order=(1,1,1),seasonal_order=(0,1,1,12),
            enforce_stationarity=False,enforce_invertibility=False).fit(disp=False)
print(fit.forecast(steps=6))
