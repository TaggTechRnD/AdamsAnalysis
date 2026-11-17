# AA72 — Isolation Forest
# Goal: Assign anomaly scores by random tree isolation.
# Packages: numpy, scikit-learn
# Check: Highest-scoring unusual records; inspect rather than automatically delete.
# Caveat: Scoring conventions differ by library; anomalies are not necessarily data errors.
# Implementation note: comparable isolation-forest families, different score conventions

import numpy as np
rng=np.random.default_rng(2026)
X=np.vstack([rng.normal(-2,.5,(60,2)),rng.normal(2,.5,(60,2)),
             np.column_stack([rng.normal(2,.5,60),rng.normal(-2,.5,60)])])

from sklearn.ensemble import IsolationForest
fit=IsolationForest(n_estimators=150,random_state=2026,contamination=.05).fit(X)
score=-fit.score_samples(X) # larger scores mean more anomalous
print("Most anomalous indices:",np.argsort(score)[-10:][::-1])
