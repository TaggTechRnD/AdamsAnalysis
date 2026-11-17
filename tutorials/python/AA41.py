# AA41 — Generalized Additive Model (GAM)
# Goal: Estimate a smooth nonlinear relationship.
# Packages: numpy, pandas, pygam
# Check: Estimated smooth, effective degrees of freedom, and uncertainty.
# Caveat: Smooth significance can be optimistic without adequate model checks; R and Python smoothing defaults differ.
# Implementation note: comparable spline-based GAM; defaults differ

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 160
x = rng.normal(size=n)
group = np.repeat(["Control", "Treatment"], n // 2)
y = 10 + 1.3 * (group == "Treatment") + 0.9 * x + rng.normal(scale=2, size=n)
d = pd.DataFrame({"y": y, "x": x, "group": group})

# Install optional dependency beforehand: pip install pygam
from pygam import LinearGAM, s
fit=LinearGAM(s(0,n_splines=10)).fit(d[["x"]].to_numpy(),d.y.to_numpy())
print(fit.summary())
