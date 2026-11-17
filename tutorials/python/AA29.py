# AA29 — Random Forest
# Goal: Classify outcomes with an ensemble of trees.
# Packages: numpy, pandas, scikit-learn
# Check: Holdout confusion matrix and class-level performance.
# Caveat: Feature importance is not causal; tune parameters with cross-validation.
# Implementation note: comparable

import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
rng = np.random.default_rng(2026)
n = 300
x1=rng.normal(size=n); x2=rng.normal(size=n); x3=rng.normal(size=n)
p=1/(1+np.exp(-(-.2+1.2*x1-.8*x2+.5*x3)))
y=rng.binomial(1,p)
d=pd.DataFrame({"x1":x1,"x2":x2,"x3":x3,"y":y})
train,test=train_test_split(d, test_size=.3, random_state=2026, stratify=d.y)

from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import confusion_matrix
fit=RandomForestClassifier(n_estimators=200,random_state=2026).fit(train[["x1","x2","x3"]],train.y)
p=fit.predict(test[["x1","x2","x3"]])
print(confusion_matrix(test.y,p))
