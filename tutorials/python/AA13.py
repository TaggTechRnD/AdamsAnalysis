# AA13 — Repeated-Measures ANOVA
# Goal: Test changes over repeated visits ignoring between-group effects.
# Packages: numpy, pandas, scipy
# Check: Within-person time F statistic.
# Caveat: For between-group effects or missing visits use mixed ANOVA/mixed model; sphericity matters with >2 visits.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 90
d = pd.MultiIndex.from_product([range(n), ["Baseline","Week6","Week12"]],
                               names=["id","time"]).to_frame(index=False)
d["group"] = np.where(d.id < n // 2, "Control", "Treatment")
subject_effect = rng.normal(0, 3, n)
t = d.time.map({"Baseline": 0, "Week6": 1, "Week12": 2}).to_numpy()
d["y"] = (30 + subject_effect[d.id.to_numpy()] + 1.2*t +
          2*(d.group.to_numpy() == "Treatment")*t + rng.normal(0,2,len(d)))

from statsmodels.stats.anova import AnovaRM
print(AnovaRM(data=d,depvar="y",subject="id",within=["time"]).fit())
