# AA61 — Gradient Boosting
# Goal: Classify disease outcomes using boosted decision trees.
# Packages: numpy, pandas, scikit-learn
# Check: Holdout confusion matrix or AUC; inspect calibration.
# Caveat: R and Python boosting implementations differ; model selection needs validation beyond a single holdout.
# Implementation note: comparable boosting families, different defaults

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

from sklearn.ensemble import GradientBoostingClassifier
from sklearn.metrics import roc_auc_score
fit=GradientBoostingClassifier(n_estimators=150,random_state=2026).fit(
    train[["x1","x2","x3"]],train.y)
prob=fit.predict_proba(test[["x1","x2","x3"]])[:,1]
print("Test AUC:",roc_auc_score(test.y,prob))
