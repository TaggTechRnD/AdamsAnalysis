# AA12 — Two-Way ANOVA
# Goal: Estimate main and interaction effects of two between-person factors.
# Packages: numpy, pandas, scipy
# Check: Group-by-dose interaction F test.
# Caveat: Interpret interaction before interpreting marginal main effects.
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
fit=smf.ols("y ~ C(group)*C(dose)",data=d).fit()
print(sm.stats.anova_lm(fit,typ=2))
