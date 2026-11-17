# AA70 — Hierarchical Clustering
# Goal: Create a hierarchy of clusters and cut at a specified level.
# Packages: numpy, scipy, scikit-learn
# Check: Ward linkage merge tree and three-group partition.
# Caveat: Linkage and scaling affect results; dendrogram proximity is not statistical significance.
# Implementation note: comparable

import numpy as np
rng=np.random.default_rng(2026)
X=np.vstack([rng.normal(-2,.5,(60,2)),rng.normal(2,.5,(60,2)),
             np.column_stack([rng.normal(2,.5,60),rng.normal(-2,.5,60)])])

from scipy.cluster.hierarchy import linkage,fcluster
from sklearn.preprocessing import StandardScaler
Z=linkage(StandardScaler().fit_transform(X),method="ward")
print("Cluster sizes:",np.bincount(fcluster(Z,3,criterion="maxclust"))[1:])
