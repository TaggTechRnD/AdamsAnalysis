# AA43 — Ordinal Logistic Regression
# Goal: Model proportional-odds cumulative category probabilities.
# Packages: MASS
# Check: Common slope odds ratios and estimated thresholds.
# Caveat: Test proportional-odds assumption; slope signs depend on cumulative-odds convention.

set.seed(2026)
n <- 280
x <- rnorm(n)
treatment <- rbinom(n, 1, 0.5)
p <- plogis(-0.5 + 0.8*x - 0.7*treatment)
y <- rbinom(n, 1, p)
d <- data.frame(y, x, treatment)

set.seed(2027)
score<-0.8*d$x-0.4*d$treatment+rnorm(nrow(d))
d$grade<-ordered(cut(score,breaks=c(-Inf,-.5,.5,Inf),labels=c("Low","Mid","High")))
fit<-MASS::polr(grade~x+treatment,data=d,method="logistic",Hess=TRUE)
print(summary(fit))
