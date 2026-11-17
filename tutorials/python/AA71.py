# AA71 — DBSCAN
# Goal: Detect density-connected clusters and possible noise points.
# Packages: numpy, scipy, scikit-learn
# Check: Cluster labels and number of unassigned/noise points.
# Caveat: Distance scale, epsilon and minimum-neighbor settings govern results.
# Implementation note: comparable

import numpy as np
rng=np.random.default_rng(2026)
X=np.vstack([rng.normal(-2,.5,(60,2)),rng.normal(2,.5,(60,2)),
             np.column_stack([rng.normal(2,.5,60),rng.normal(-2,.5,60)])])

from sklearn.cluster import DBSCAN
from sklearn.preprocessing import StandardScaler
fit=DBSCAN(eps=.5,min_samples=5).fit(StandardScaler().fit_transform(X))
print("Labels (-1 noise):",np.unique(fit.labels_,return_counts=True))
