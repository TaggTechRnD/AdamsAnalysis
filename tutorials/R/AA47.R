# AA47 — Quantile Regression
# Goal: Estimate conditional median shifts instead of mean shifts.
# Packages: quantreg
# Check: Median regression coefficients at tau=0.5.
# Caveat: Conditional quantile coefficients are not changes in unconditional population medians.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

fit<-quantreg::rq(y~x+group,tau=.5,data=d)
print(summary(fit,se="nid"))
