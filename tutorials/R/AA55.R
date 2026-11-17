# AA55 — Mediation Analysis
# Goal: Estimate a proposed indirect pathway through mediator m.
# Packages: mediation
# Check: Estimated indirect effect and sensitivity to assumptions.
# Caveat: Mediation identification needs strong treatment–mediator and mediator–outcome confounding assumptions; Python uses a simpler product estimator.

set.seed(2026)
n<-450
x<-rnorm(n)
p_treat<-plogis(-.2+.9*x)
treated<-rbinom(n,1,p_treat)
y<-4+1.6*treated+1.4*x+rnorm(n,sd=1.2)
d<-data.frame(y,x,treated)

set.seed(2027)
d$m <- .8*d$treated + .5*d$x + rnorm(nrow(d))
d$y <- .5*d$treated + .6*d$m + .5*d$x + rnorm(nrow(d))
mfit <- lm(m~treated+x,data=d)
yfit <- lm(y~treated+m+x,data=d)
fit <- mediation::mediate(mfit,yfit,treat="treated",mediator="m",sims=200,
                          boot=FALSE)
print(summary(fit))
