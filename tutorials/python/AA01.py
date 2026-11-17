# AA01 — Mean and Standard Deviation
# Goal: Summarize a continuous health measurement.
# Packages: numpy, pandas, scipy
# Check: Compare the sample mean with the SD, both in outcome units.
# Caveat: The SD is not a standard error; outliers can affect both summaries.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 160
x = rng.normal(size=n)
group = np.repeat(["Control", "Treatment"], n // 2)
y = 10 + 1.3 * (group == "Treatment") + 0.9 * x + rng.normal(scale=2, size=n)
d = pd.DataFrame({"y": y, "x": x, "group": group})

print(d.y.agg(["mean","std","count"]))
