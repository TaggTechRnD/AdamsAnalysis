# AA38 — MANOVA
# Goal: Test whether independent groups differ on multiple continuous outcomes jointly.
# Packages: numpy, pandas, statsmodels
# Check: Pillai trace or other multivariate statistic.
# Caveat: Check multivariate outliers and dependence; multivariate significance is not specific to one outcome.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 160
x = rng.normal(size=n)
group = np.repeat(["Control", "Treatment"], n // 2)
y = 10 + 1.3 * (group == "Treatment") + 0.9 * x + rng.normal(scale=2, size=n)
d = pd.DataFrame({"y": y, "x": x, "group": group})

import statsmodels.api as sm
from statsmodels.multivariate.manova import MANOVA
rng2=np.random.default_rng(2027)
d["y2"]=5+.7*d.x+.6*(d.group=="Treatment")+rng2.normal(size=len(d))
fit=MANOVA.from_formula("y + y2 ~ C(group)",data=d)
print(fit.mv_test())
