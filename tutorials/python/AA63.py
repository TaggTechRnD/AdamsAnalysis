# AA63 — LASSO Regression
# Goal: Select/shrink predictors using the L1 penalty.
# Packages: numpy, pandas, scikit-learn
# Check: Nonzero coefficients, chosen penalty and holdout prediction error.
# Caveat: Variable selection may be unstable across samples; naive post-selection p-values are invalid.
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

from sklearn.linear_model import LassoCV
from sklearn.metrics import mean_squared_error
cols=["x1","x2","x3"]
fit=LassoCV(cv=5,random_state=2026,max_iter=5000).fit(train[cols],train.y)
print("Coefficients:",fit.coef_)
print("Test MSE:",mean_squared_error(test.y,fit.predict(test[cols])))
