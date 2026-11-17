# AA11 — One-Way ANOVA
# Goal: Compare means across independent group levels.
# Packages: numpy, pandas, scipy
# Check: Between-group F statistic and p-value.
# Caveat: Check independent units, variance pattern, and residuals.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
d = pd.MultiIndex.from_product([["Control","Treatment"],["Low","High"],range(40)],
                               names=["group","dose","rep"]).to_frame(index=False)
d["y"] = (10 + 2*(d.group == "Treatment") + (d.dose == "High") +
          2*(d.group == "Treatment")*(d.dose == "High") + rng.normal(0, 2, len(d)))

import statsmodels.api as sm
import statsmodels.formula.api as smf
fit=smf.ols("y ~ C(group)",data=d).fit()
print(sm.stats.anova_lm(fit,typ=2))
