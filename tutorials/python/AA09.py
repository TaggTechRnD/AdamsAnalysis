# AA09 — Mann-Whitney U Test
# Goal: Compare independent rank distributions.
# Packages: numpy, pandas, scipy
# Check: Mann–Whitney U/W and p-value.
# Caveat: Not generally a test of median differences unless distribution shapes support that interpretation.
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
print(stats.mannwhitneyu(d.loc[d.group=="Control","y"],
                        d.loc[d.group=="Treatment","y"],alternative="two-sided"))
