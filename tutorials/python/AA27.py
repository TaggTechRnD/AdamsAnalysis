# AA27 — Exploratory Factor Analysis (EFA)
# Goal: Explore a two-factor measurement structure.
# Packages: numpy, pandas, factor-analyzer
# Check: Rotated item loadings and uniquenesses.
# Caveat: Factor count and rotation are substantive choices; factor labels are interpretive.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 240
f1 = rng.normal(size=n); f2 = .3*f1 + rng.normal(size=n)
d = pd.DataFrame({
 "a1":.9*f1+rng.normal(0,.5,n), "a2":.8*f1+rng.normal(0,.6,n),
 "a3":.7*f1+rng.normal(0,.6,n), "b1":.9*f2+rng.normal(0,.5,n),
 "b2":.8*f2+rng.normal(0,.6,n), "b3":.7*f2+rng.normal(0,.6,n)})

# Install optional dependency beforehand: pip install factor_analyzer
from factor_analyzer import FactorAnalyzer
fit=FactorAnalyzer(n_factors=2,rotation="varimax",method="ml").fit(d)
print("Loadings:\n",fit.loadings_)
print("Uniquenesses:",fit.get_uniquenesses())
