# AA23 — Poisson Regression
# Goal: Model event rates with person-time/exposure offset.
# Packages: stats
# Check: Rate ratio exp(beta) and fit diagnostics.
# Caveat: Assess overdispersion and excess zeros; offset assumes coefficient fixed at one.

set.seed(2026)
n <- 280
x <- rnorm(n)
exposure <- runif(n, 0.5, 2)
mu <- exp(0.5 + 0.6*x + log(exposure))
y <- rpois(n, lambda = mu)
d <- data.frame(y, x, exposure)

fit<-glm(y~x+offset(log(exposure)),family=poisson(),data=d)
print(summary(fit))
print(exp(coef(fit)))
