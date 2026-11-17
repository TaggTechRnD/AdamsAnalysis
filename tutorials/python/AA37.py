# AA37 — Welch's ANOVA
# Goal: Compare three group means under unequal variances.
# Packages: numpy, pandas, scipy
# Check: Welch ANOVA F and approximate degrees of freedom.
# Caveat: Follow-up comparisons must also handle unequal variances.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
d = pd.MultiIndex.from_product([["Control","Treatment"],["Low","High"],range(40)],
                               names=["group","dose","rep"]).to_frame(index=False)
d["y"] = (10 + 2*(d.group == "Treatment") + (d.dose == "High") +
          2*(d.group == "Treatment")*(d.dose == "High") + rng.normal(0, 2, len(d)))

from scipy import stats
rng=np.random.default_rng(77)
groups=[rng.normal(0,1,40),rng.normal(1,3,40),rng.normal(2,5,40)]
print(stats.f_oneway(*groups,equal_var=False))
