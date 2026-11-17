# AA40 — Polynomial Regression
# Goal: Fit quadratic association allowing curvature.
# Packages: stats
# Check: Linear and squared coefficients and fitted curve.
# Caveat: Polynomial terms describe shape; extrapolation can be unstable.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

fit<-lm(y~poly(x,2,raw=TRUE),data=d)
print(summary(fit))
