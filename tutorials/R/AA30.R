# AA30 — Difference-in-Differences (DiD)
# Goal: Estimate treated-minus-control difference in pre/post changes.
# Packages: lmtest, sandwich
# Check: Coefficient on treated:post and cluster-robust uncertainty.
# Caveat: Two observed periods cannot test pre-treatment parallel trends; this illustration ASSUMES parallel trends.

set.seed(2026)
n<-160
d<-expand.grid(id=seq_len(n),post=0:1)
d$treated<-as.integer(d$id>n/2)
individual<-rnorm(n,sd=2)
d$y<-10 + individual[d$id] + 1.5*d$post + 2*d$treated*d$post + rnorm(nrow(d))

# Repeated observations: cluster-robust standard errors by id
fit<-lm(y~treated*post,data=d)
print(lmtest::coeftest(fit,vcov.=sandwich::vcovCL(fit,cluster=d$id)))
