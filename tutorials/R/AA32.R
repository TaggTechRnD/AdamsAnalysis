# AA32 — Confidence Intervals
# Goal: Calculate a 95% confidence interval for a population mean under sampling assumptions.
# Packages: stats
# Check: Lower and upper confidence limits.
# Caveat: The 95% interval is not a 95% probability interval for individual outcomes.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

print(t.test(d$y,conf.level=.95)$conf.int)
