# AA46 — Beta Regression
# Goal: Model a proportion strictly between zero and one.
# Packages: numpy, pandas, statsmodels
# Check: Mean-link coefficient and precision/dispersion estimates.
# Caveat: Exact zeros or ones need a different model or justified boundary treatment.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 160
x = rng.normal(size=n)
group = np.repeat(["Control", "Treatment"], n // 2)
y = 10 + 1.3 * (group == "Treatment") + 0.9 * x + rng.normal(scale=2, size=n)
d = pd.DataFrame({"y": y, "x": x, "group": group})

from statsmodels.othermod.betareg import BetaModel
prop=rng.beta(2+np.exp(.5*d.x.to_numpy()),4)
d["prop"]=prop
fit=BetaModel.from_formula("prop ~ x",data=d).fit(disp=False)
print(fit.summary())
