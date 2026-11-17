# AA33 — Kendall's Tau
# Goal: Estimate ordinal concordance.
# Packages: numpy, pandas, scipy
# Check: Kendall tau and p-value.
# Caveat: Association is noncausal and may reflect confounding.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 160
x = rng.normal(size=n)
group = np.repeat(["Control", "Treatment"], n // 2)
y = 10 + 1.3 * (group == "Treatment") + 0.9 * x + rng.normal(scale=2, size=n)
d = pd.DataFrame({"y": y, "x": x, "group": group})

from scipy import stats
print(stats.kendalltau(d.x,d.y))
