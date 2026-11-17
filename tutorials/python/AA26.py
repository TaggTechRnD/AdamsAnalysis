# AA26 — Principal Component Analysis (PCA)
# Goal: Find orthogonal directions explaining variability in standardized indicators.
# Packages: numpy, pandas, scikit-learn
# Check: Explained-variance ratios and loadings.
# Caveat: Component directions are descriptive; PCA does not prove latent constructs.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 240
f1 = rng.normal(size=n); f2 = .3*f1 + rng.normal(size=n)
d = pd.DataFrame({
 "a1":.9*f1+rng.normal(0,.5,n), "a2":.8*f1+rng.normal(0,.6,n),
 "a3":.7*f1+rng.normal(0,.6,n), "b1":.9*f2+rng.normal(0,.5,n),
 "b2":.8*f2+rng.normal(0,.6,n), "b3":.7*f2+rng.normal(0,.6,n)})

from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
z=StandardScaler().fit_transform(d)
fit=PCA().fit(z)
print("Variance explained:",fit.explained_variance_ratio_)
print("Loadings:\n",fit.components_.T)
