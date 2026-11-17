# AA05 — Spearman Correlation
# Goal: Estimate monotonic association based on ranks.
# Packages: numpy, pandas, scipy
# Check: Spearman rho and p-value.
# Caveat: A monotonic trend is not necessarily linear or causal.
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
print(stats.spearmanr(d.x,d.y))
