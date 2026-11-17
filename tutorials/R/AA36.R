# AA36 — One-Sample t-Test
# Goal: Compare sample mean with a prespecified benchmark of 10.
# Packages: stats
# Check: Mean difference, t statistic, p-value, CI.
# Caveat: Benchmark must be prespecified; independence still matters.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

print(t.test(d$y,mu=10))
