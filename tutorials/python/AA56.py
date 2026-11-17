# AA56 — Latent Growth Curve Modeling
# Goal: Represent repeated outcomes via latent intercept and linear change factors.
# Packages: numpy, pandas, semopy
# Check: Mean and variation of growth factors, where estimated.
# Caveat: Growth identification and mean structure require special care; semopy Model does not exactly replicate lavaan::growth.
# Implementation note: analog: SEM growth formulation with different mean-structure defaults

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 90
d = pd.MultiIndex.from_product([range(n), ["Baseline","Week6","Week12"]],
                               names=["id","time"]).to_frame(index=False)
d["group"] = np.where(d.id < n // 2, "Control", "Treatment")
subject_effect = rng.normal(0, 3, n)
t = d.time.map({"Baseline": 0, "Week6": 1, "Week12": 2}).to_numpy()
d["y"] = (30 + subject_effect[d.id.to_numpy()] + 1.2*t +
          2*(d.group.to_numpy() == "Treatment")*t + rng.normal(0,2,len(d)))

# Install optional dependency beforehand: pip install semopy
from semopy import Model
wide=d.pivot(index="id",columns="time",values="y")
wide=wide[["Baseline","Week6","Week12"]].copy()
wide.columns=["y_0","y_1","y_2"]
# Demonstrates an SEM-based growth specification; estimator differs from lavaan::growth
model="i =~ 1*y_0 + 1*y_1 + 1*y_2\ns =~ 0*y_0 + 1*y_1 + 2*y_2\ni ~~ s"
fit=Model(model)
fit.fit(wide)
print(fit.inspect())
