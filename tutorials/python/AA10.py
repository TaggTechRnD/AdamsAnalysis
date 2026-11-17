# AA10 — Wilcoxon Signed-Rank Test
# Goal: Test whether paired changes are centered at zero in a signed-rank framework.
# Packages: numpy, pandas, scipy
# Check: Signed-rank statistic and p-value.
# Caveat: Requires appropriate symmetry for a median-change interpretation.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 90
before = rng.normal(125, 13, n)
after = before - 5 + rng.normal(0, 7, n)
d = pd.DataFrame({"id": np.arange(n), "before": before, "after": after})

from scipy import stats
print(stats.wilcoxon(d.after-d.before,alternative="two-sided"))
