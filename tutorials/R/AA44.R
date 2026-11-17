# AA44 — Negative Binomial Regression
# Goal: Model overdispersed event counts.
# Packages: MASS
# Check: Log count ratio, dispersion parameter and model uncertainty.
# Caveat: Compare with Poisson dispersion; NB models do not automatically handle excess structural zeros.

set.seed(2026)
n <- 300
x <- rnorm(n)
mu <- exp(0.4 + 0.55*x)
y <- rnbinom(n, size = 1.2, mu = mu)
d <- data.frame(y, x)

fit<-MASS::glm.nb(y~x,data=d)
print(summary(fit))
print(exp(coef(fit)))
