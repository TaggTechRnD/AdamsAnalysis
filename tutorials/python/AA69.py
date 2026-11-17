# AA69 — K-Means Clustering
# Goal: Partition unlabeled cases into three compact clusters.
# Packages: numpy, scikit-learn
# Check: Cluster sizes, within-cluster sum of squares.
# Caveat: Number of clusters is specified, not inferred; no inherent p-value.
# Implementation note: comparable

import numpy as np
rng=np.random.default_rng(2026)
X=np.vstack([rng.normal(-2,.5,(60,2)),rng.normal(2,.5,(60,2)),
             np.column_stack([rng.normal(2,.5,60),rng.normal(-2,.5,60)])])

from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
fit=KMeans(n_clusters=3,n_init=20,random_state=2026).fit(StandardScaler().fit_transform(X))
print("Cluster sizes:",np.bincount(fit.labels_))
print("Inertia:",fit.inertia_)
