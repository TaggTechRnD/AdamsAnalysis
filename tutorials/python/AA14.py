# AA14 — Mixed-Design ANOVA
# Goal: Evaluate whether treatment and control groups change differently over visits.
# Packages: numpy, pandas, pingouin
# Check: Group × time interaction, F statistic, partial eta-squared; check corrections.
# Caveat: Requires subject IDs, independent groups, complete/balanced visits for this example; a significant interaction alone is not proof of causality.
# Implementation note: comparable

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

# Install optional dependency beforehand: pip install pingouin
import pingouin as pg
result=pg.mixed_anova(data=d,dv="y",within="time",between="group",subject="id")
print(result)
