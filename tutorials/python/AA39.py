# AA39 — McNemar's Test
# Goal: Test change in a paired binary characteristic.
# Packages: numpy, pandas, statsmodels
# Check: McNemar p-value based on discordant pairs.
# Caveat: Within-person paired 2×2 table is required; independent chi-square is inappropriate.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 90
before = rng.normal(125, 13, n)
after = before - 5 + rng.normal(0, 7, n)
d = pd.DataFrame({"id": np.arange(n), "before": before, "after": after})

from statsmodels.stats.contingency_tables import mcnemar
pre=rng.binomial(1,.35,len(d))
post=np.where(pre==1,rng.binomial(1,.70,len(d)),rng.binomial(1,.23,len(d)))
ct=pd.crosstab(pre,post).reindex(index=[0,1],columns=[0,1],fill_value=0)
print(mcnemar(ct.to_numpy(),exact=False,correction=True))
