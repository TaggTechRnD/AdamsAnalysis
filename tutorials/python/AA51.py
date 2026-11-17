# AA51 — Log-Rank Test
# Goal: Compare event-time curves between treatment arms.
# Packages: numpy, pandas, lifelines
# Check: Log-rank chi-square statistic and p-value.
# Caveat: Censoring assumptions and crossing hazards affect interpretation.
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
from lifelines.statistics import logrank_test
a=d[d.treatment==0];b=d[d.treatment==1]
print(logrank_test(a.time,b.time,event_observed_A=a.event,event_observed_B=b.event).summary)
