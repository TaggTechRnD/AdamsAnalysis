# AA03 — Frequencies and Proportions
# Goal: Tabulate binary response frequencies.
# Packages: numpy, pandas, scipy
# Check: Counts and sample proportions in each category.
# Caveat: Specify denominator and missing-data policy.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 280
x = rng.normal(size=n)
treatment = rng.binomial(1, .5, n)
p = 1 / (1 + np.exp(-(-.5 + .8*x - .7*treatment)))
y = rng.binomial(1, p)
d = pd.DataFrame({"y": y,"x": x,"treatment":treatment})

print(d.y.value_counts().sort_index())
print(d.y.value_counts(normalize=True).sort_index())
