# AA46 — Beta Regression
# Goal: Model a proportion strictly between zero and one.
# Packages: betareg
# Check: Mean-link coefficient and precision/dispersion estimates.
# Caveat: Exact zeros or ones need a different model or justified boundary treatment.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

set.seed(2027)
d$prop<-rbeta(nrow(d),shape1=2+exp(.5*d$x),shape2=4)
fit<-betareg::betareg(prop~x,data=d)
print(summary(fit))
