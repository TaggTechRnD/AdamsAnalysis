# AA28 — Decision Tree
# Goal: Fit an interpretable classification tree and evaluate it on holdout data.
# Packages: numpy, pandas, scikit-learn
# Check: Confusion matrix or test accuracy and tree splits.
# Caveat: A single tree is unstable; avoid evaluating it only on the training set.
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

from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score
fit=DecisionTreeClassifier(max_depth=3,random_state=2026).fit(train[["x1","x2","x3"]],train.y)
p=fit.predict(test[["x1","x2","x3"]])
print("Test accuracy:",accuracy_score(test.y,p))
