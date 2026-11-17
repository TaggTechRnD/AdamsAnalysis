# AA53 — Path Analysis
# Goal: Estimate prespecified observed-variable directional regression paths.
# Packages: numpy, pandas, semopy
# Check: Direct path coefficients, uncertainty and fit.
# Caveat: Arrows express modeled hypotheses, not proof of causal direction.
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
from semopy import Model
model="a2 ~ a1\nb1 ~ a1 + a2"
fit=Model(model)
fit.fit(d)
print(fit.inspect())
