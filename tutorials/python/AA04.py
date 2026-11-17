# AA04 — Pearson Correlation
# Goal: Estimate linear association between two measurements.
# Packages: numpy, pandas, scipy
# Check: Pearson r and p-value; inspect a scatterplot separately.
# Caveat: Linear association is not causal; extreme points can dominate.
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
print(stats.pearsonr(d.x,d.y))
