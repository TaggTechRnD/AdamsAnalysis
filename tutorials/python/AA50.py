# AA50 — Kaplan-Meier Analysis
# Goal: Estimate event-free probability over time by treatment arm.
# Packages: numpy, pandas, lifelines
# Check: Kaplan–Meier survival estimates at specific times.
# Caveat: Requires non-informative censoring for conventional interpretation.
# Implementation note: comparable

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 250
x = rng.normal(size=n)
treatment = rng.binomial(1, .5, n)
rate = .08*np.exp(.5*x - .5*treatment)
true_time = rng.exponential(scale=1/rate)
censor_time = rng.uniform(5,22,n)
time = np.minimum(true_time,censor_time)
event = (true_time <= censor_time).astype(int)
d = pd.DataFrame({"time":time,"event":event,"x":x,"treatment":treatment})

# Install optional dependency beforehand: pip install lifelines
from lifelines import KaplanMeierFitter
for arm,part in d.groupby("treatment"):
    km=KaplanMeierFitter().fit(part.time,part.event,label=f"Arm {arm}")
    print(arm,km.survival_function_at_times([5,10]))
