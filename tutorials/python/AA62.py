# AA62 — Ridge Regression
# Goal: Shrink correlated predictor coefficients using ridge penalization.
# Packages: numpy, pandas, scikit-learn
# Check: Cross-validated penalty and test MSE.
# Caveat: Regularization improves prediction but does not make coefficients causal.
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

from sklearn.linear_model import RidgeCV
from sklearn.metrics import mean_squared_error
cols=["x1","x2","x3"]
fit=RidgeCV(alphas=np.logspace(-3,3,30),cv=5).fit(train[cols],train.y)
print("Test MSE:",mean_squared_error(test.y,fit.predict(test[cols])))
