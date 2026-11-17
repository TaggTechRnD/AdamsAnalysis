# AA07 — Welch's t-Test
# Goal: Compare independent means without requiring equal variances.
# Packages: stats
# Check: Welch t statistic, approximate df and p-value.
# Caveat: Independence and suitable outcome scale remain necessary.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

print(t.test(y ~ group, data=d, var.equal=FALSE))
