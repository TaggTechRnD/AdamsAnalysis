# AA24 — Linear Mixed-Effects Model
# Goal: Fit correlated repeated measurements using a random participant intercept.
# Packages: numpy, pandas, statsmodels
# Check: Fixed group/time/interaction effects and random intercept variance.
# Caveat: Random-effects structure and missingness assumptions require checking.
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

import statsmodels.formula.api as smf
fit=smf.mixedlm("y ~ C(group)*C(time)",data=d,groups=d["id"]).fit(reml=False)
print(fit.summary())
