# AA02 — Median and Interquartile Range
# Goal: Summarize the center and spread robustly.
# Packages: numpy, pandas, scipy
# Check: Median, 25th and 75th percentiles; IQR = Q3 − Q1.
# Caveat: Quartiles are sample descriptions, not confidence limits.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 160
x = rng.normal(size=n)
group = np.repeat(["Control", "Treatment"], n // 2)
y = 10 + 1.3 * (group == "Treatment") + 0.9 * x + rng.normal(scale=2, size=n)
d = pd.DataFrame({"y": y, "x": x, "group": group})

print(d.y.quantile([.25,.5,.75]))
print("IQR:", d.y.quantile(.75)-d.y.quantile(.25))
