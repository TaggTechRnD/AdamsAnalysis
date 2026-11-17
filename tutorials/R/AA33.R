# AA33 — Kendall's Tau
# Goal: Estimate ordinal concordance.
# Packages: stats
# Check: Kendall tau and p-value.
# Caveat: Association is noncausal and may reflect confounding.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

print(cor.test(d$x,d$y,method="kendall",exact=FALSE))
