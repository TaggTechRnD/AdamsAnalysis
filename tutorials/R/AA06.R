# AA06 — Independent Samples t-Test
# Goal: Compare means between independent groups under equal-variance assumption.
# Packages: stats
# Check: Mean difference and t test; assess group variances.
# Caveat: Equal-variance assumption is explicit; use Welch if questionable.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

print(t.test(y ~ group, data=d, var.equal=TRUE))
