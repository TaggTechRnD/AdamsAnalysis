# AA52 — Confirmatory Factor Analysis (CFA)
# Goal: Confirm a prespecified two-factor measurement model.
# Packages: numpy, pandas, semopy
# Check: Standardized loadings and global model fit statistics.
# Caveat: Good global fit alone does not establish measurement validity; check identification and residuals.
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
model="F1 =~ a1 + a2 + a3\nF2 =~ b1 + b2 + b3"
fit=Model(model)
fit.fit(d)
print(calc_stats(fit).loc[["Value"], ["CFI","TLI","RMSEA"]])
print(fit.inspect())
