# AA25 — Generalized Linear Mixed Model (GLMM)
# Goal: Model binary outcomes clustered within participants.
# Packages: numpy, pandas, statsmodels
# Check: Conditional fixed effects and between-person heterogeneity.
# Caveat: Python uses a Bayesian variational fit; numerical estimates and uncertainty differ from frequentist lme4.
# Implementation note: analog: frequentist versus Bayesian estimators

import numpy as np
import pandas as pd
rng = np.random.default_rng(2026)
n = 280
x = rng.normal(size=n)
treatment = rng.binomial(1, .5, n)
p = 1 / (1 + np.exp(-(-.5 + .8*x - .7*treatment)))
y = rng.binomial(1, p)
d = pd.DataFrame({"y": y,"x": x,"treatment":treatment})

# Bayesian GLMM demonstration; not the same estimator as lme4::glmer
import statsmodels.api as sm
d["id"]=np.repeat(np.arange(70),4)
subject=rng.normal(size=70)
p=1/(1+np.exp(-(-.5+.8*d.x.to_numpy()+.6*subject[d.id.to_numpy()])))
d["y"]=rng.binomial(1,p)
fit=sm.BinomialBayesMixedGLM.from_formula("y ~ x",{"id":"0 + C(id)"},d).fit_vb()
print(fit.summary())
