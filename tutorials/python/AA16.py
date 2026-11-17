# AA16 — Kruskal-Wallis Test
# Goal: Compare rank distributions among independent groups.
# Packages: numpy, pandas, scipy
# Check: Kruskal–Wallis H and p-value.
# Caveat: Does not automatically test equality of medians for differing distribution shapes.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
d = pd.MultiIndex.from_product([["Control","Treatment"],["Low","High"],range(40)],
                               names=["group","dose","rep"]).to_frame(index=False)
d["y"] = (10 + 2*(d.group == "Treatment") + (d.dose == "High") +
          2*(d.group == "Treatment")*(d.dose == "High") + rng.normal(0, 2, len(d)))

from scipy import stats
samples=[part.y.to_numpy() for _,part in d.groupby("group")]
print(stats.kruskal(*samples))
