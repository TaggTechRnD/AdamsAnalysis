# AA08 — Paired t-Test
# Goal: Evaluate within-person mean change.
# Packages: numpy, pandas, scipy
# Check: Mean paired difference, CI, t statistic.
# Caveat: Check distribution of paired differences, not separate marginal normality.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 90
before = rng.normal(125, 13, n)
after = before - 5 + rng.normal(0, 7, n)
d = pd.DataFrame({"id": np.arange(n), "before": before, "after": after})

from scipy import stats
print(stats.ttest_rel(d.after,d.before))
print("Mean change:",(d.after-d.before).mean())
