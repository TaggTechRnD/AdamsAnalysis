# AA21 — Multiple Linear Regression
# Goal: Estimate adjusted slopes for several predictors and evaluate prediction error.
# Packages: numpy, pandas, scipy
# Check: Coefficients, intervals, and held-out MSE.
# Caveat: Correlated predictors complicate attribution; training fit is not out-of-sample accuracy.
# Implementation note: comparable

import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
rng=np.random.default_rng(2026)
n=300
x1=rng.normal(size=n);x2=rng.normal(size=n);x3=rng.normal(size=n)
y=3+2*x1-x2+.7*x3+rng.normal(0,1.5,n)
d=pd.DataFrame({"y":y,"x1":x1,"x2":x2,"x3":x3})
train,test=train_test_split(d,test_size=.3,random_state=2026)

import statsmodels.formula.api as smf
fit=smf.ols("y ~ x1+x2+x3",data=train).fit()
print(fit.summary())
print("Held-out MSE:",np.mean((fit.predict(test)-test.y)**2))
