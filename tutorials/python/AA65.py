# AA65 — Support Vector Machine (SVM)
# Goal: Learn a nonlinear decision boundary with a support-vector machine.
# Packages: numpy, pandas, scikit-learn
# Check: Test accuracy/confusion and sensitivity to hyperparameters.
# Caveat: Scale predictors and tune C/gamma before deployment; outputs are not calibrated probabilities.
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

from sklearn.svm import SVC
from sklearn.metrics import accuracy_score
fit=SVC(kernel="rbf",C=1,random_state=2026).fit(train[["x1","x2","x3"]],train.y)
print("Test accuracy:",accuracy_score(test.y,fit.predict(test[["x1","x2","x3"]])))
