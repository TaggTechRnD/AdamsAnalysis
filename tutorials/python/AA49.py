# AA49 — Cox Proportional Hazards Regression
# Goal: Model covariate effects on the hazard of an event.
# Packages: numpy, pandas, lifelines
# Check: Hazard ratios and CIs; check proportional hazards.
# Caveat: A hazard ratio is not a risk ratio or a difference in mean survival time.
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
from lifelines import CoxPHFitter
fit=CoxPHFitter().fit(d,duration_col="time",event_col="event")
print(fit.summary[["coef","exp(coef)","p"]])
