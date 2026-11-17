# AA66 — k-Nearest Neighbors (kNN)
# Goal: Classify a new record using nearby training observations.
# Packages: numpy, pandas, scikit-learn
# Check: Holdout classification accuracy and class counts.
# Caveat: Distance metric and feature scaling strongly affect results.
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

from sklearn.neighbors import KNeighborsClassifier
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score
cols=["x1","x2","x3"]
fit=make_pipeline(StandardScaler(),KNeighborsClassifier(n_neighbors=7)).fit(train[cols],train.y)
print("Test accuracy:",accuracy_score(test.y,fit.predict(test[cols])))
