# AA41 — Generalized Additive Model (GAM)
# Goal: Estimate a smooth nonlinear relationship.
# Packages: mgcv
# Check: Estimated smooth, effective degrees of freedom, and uncertainty.
# Caveat: Smooth significance can be optimistic without adequate model checks; R and Python smoothing defaults differ.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

fit<-mgcv::gam(y~s(x,k=10),data=d,method="REML")
print(summary(fit))
