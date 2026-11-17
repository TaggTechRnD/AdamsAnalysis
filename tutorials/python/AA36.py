# AA36 — One-Sample t-Test
# Goal: Compare sample mean with a prespecified benchmark of 10.
# Packages: numpy, pandas, scipy
# Check: Mean difference, t statistic, p-value, CI.
# Caveat: Benchmark must be prespecified; independence still matters.
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
print(stats.ttest_1samp(d.y,popmean=10))
