# AA54 — Structural Equation Modeling (SEM)
# Goal: Fit a structural relationship between two measured latent constructs.
# Packages: numpy, pandas, semopy
# Check: Latent regression slope, standardized loadings and fit indices.
# Caveat: Equivalent covariance patterns can have different causal explanations.
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

# Install optional dependency beforehand: pip install semopy
from semopy import Model, calc_stats
model="F1 =~ a1+a2+a3\nF2 =~ b1+b2+b3\nF2 ~ F1"
fit=Model(model)
fit.fit(d)
print(calc_stats(fit).loc[["Value"],["CFI","RMSEA"]])
print(fit.inspect())
