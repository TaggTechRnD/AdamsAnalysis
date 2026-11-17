# AA20 — Simple Linear Regression
# Goal: Estimate a linear slope relating x to continuous y.
# Packages: stats
# Check: Regression slope, CI and R-squared.
# Caveat: Review residual assumptions; slope does not imply a causal relationship.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

fit<-lm(y~x,data=d)
print(summary(fit))
print(confint(fit))
