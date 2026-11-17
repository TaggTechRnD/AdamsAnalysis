# AA67 — Naive Bayes
# Goal: Use a conditional-independence classification baseline.
# Packages: numpy, pandas, scikit-learn
# Check: Holdout confusion matrix.
# Caveat: Conditional independence is usually approximate; poor calibration is possible.
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

from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import confusion_matrix
cols=["x1","x2","x3"]
fit=GaussianNB().fit(train[cols],train.y)
print(confusion_matrix(test.y,fit.predict(test[cols])))
