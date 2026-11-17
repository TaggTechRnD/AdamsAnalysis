# AA60 — Propensity Score Methods
# Goal: Estimate inverse-probability-weighted treatment difference using measured covariate x.
# Packages: lmtest, sandwich
# Check: Weighted treatment coefficient, weight range and covariate balance (to check separately).
# Caveat: Truncation, overlap, covariate balance, missing confounders, and variance estimation require care; not automatic causal proof.

set.seed(2026)
n<-450
x<-rnorm(n)
p_treat<-plogis(-.2+.9*x)
treated<-rbinom(n,1,p_treat)
y<-4+1.6*treated+1.4*x+rnorm(n,sd=1.2)
d<-data.frame(y,x,treated)

psfit<-glm(treated~x,family=binomial(),data=d)
ps<-pmin(pmax(predict(psfit,type="response"),.02),.98)
w<-ifelse(d$treated==1,1/ps,1/(1-ps))
fit<-lm(y~treated,data=d,weights=w)
print(lmtest::coeftest(fit,vcov.=sandwich::vcovHC(fit,type="HC1")))
print(tapply(w,d$treated,summary))
