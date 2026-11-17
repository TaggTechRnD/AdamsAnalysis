# AA08 — Paired t-Test
# Goal: Evaluate within-person mean change.
# Packages: stats
# Check: Mean paired difference, CI, t statistic.
# Caveat: Check distribution of paired differences, not separate marginal normality.

set.seed(2026)
n <- 90
before <- rnorm(n, mean = 125, sd = 13)
after <- before - 5 + rnorm(n, sd = 7)
d <- data.frame(id = seq_len(n), before, after)

print(t.test(d$after,d$before,paired=TRUE))
