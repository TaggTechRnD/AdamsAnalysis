# AA34 — Point-Biserial Correlation
# Goal: Quantify association of a binary group indicator and a numerical outcome (here binary for illustration).
# Packages: numpy, pandas, scipy
# Check: Point-biserial correlation magnitude and p-value.
# Caveat: Continuous outcome and binary group indicator; interpretation is associative, not causal.
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
indicator=(d.group=="Treatment").astype(int)
print(stats.pointbiserialr(indicator,d.y))
