# AA06 — Independent Samples t-Test
# Goal: Compare means between independent groups under equal-variance assumption.
# Packages: numpy, pandas, scipy
# Check: Mean difference and t test; assess group variances.
# Caveat: Equal-variance assumption is explicit; use Welch if questionable.
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
u=d.loc[d.group=="Control","y"]
v=d.loc[d.group=="Treatment","y"]
print(stats.ttest_ind(u,v,equal_var=True))
