# AA64 — Elastic Net Regression
# Goal: Combine L1 and L2 coefficient penalties.
# Packages: numpy, pandas, scikit-learn
# Check: Selected penalty and coefficient shrinkage.
# Caveat: The R glmnet and sklearn penalty parameterizations are not numerically identical.
# Implementation note: comparable penalties, different lambda/alpha conventions

import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
rng=np.random.default_rng(2026)
n=300
x1=rng.normal(size=n);x2=rng.normal(size=n);x3=rng.normal(size=n)
y=3+2*x1-x2+.7*x3+rng.normal(0,1.5,n)
d=pd.DataFrame({"y":y,"x1":x1,"x2":x2,"x3":x3})
train,test=train_test_split(d,test_size=.3,random_state=2026)

from sklearn.linear_model import ElasticNetCV
fit=ElasticNetCV(l1_ratio=.5,cv=5,random_state=2026,max_iter=5000).fit(
    train[["x1","x2","x3"]],train.y)
print("Alpha:",fit.alpha_,"coefficients:",fit.coef_)
