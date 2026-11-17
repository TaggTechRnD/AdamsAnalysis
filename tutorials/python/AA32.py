# AA32 — Confidence Intervals
# Goal: Calculate a 95% confidence interval for a population mean under sampling assumptions.
# Packages: numpy, pandas, scipy
# Check: Lower and upper confidence limits.
# Caveat: The 95% interval is not a 95% probability interval for individual outcomes.
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
m=d.y.mean(); se=d.y.sem();df=len(d)-1
print(stats.t.interval(.95,df,loc=m,scale=se))
