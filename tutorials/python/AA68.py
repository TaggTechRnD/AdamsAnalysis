# AA68 — Artificial Neural Network
# Goal: Classify binary outcomes using a small feed-forward neural network.
# Packages: numpy, pandas, scikit-learn
# Check: Holdout accuracy and convergence diagnostics.
# Caveat: Training is stochastic and sensitive to scaling, early stopping and model capacity.
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

from sklearn.neural_network import MLPClassifier
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score
cols=["x1","x2","x3"]
fit=make_pipeline(StandardScaler(),MLPClassifier(hidden_layer_sizes=(4,),
                 max_iter=1000,random_state=2026,early_stopping=True)).fit(train[cols],train.y)
print("Test accuracy:",accuracy_score(test.y,fit.predict(test[cols])))
