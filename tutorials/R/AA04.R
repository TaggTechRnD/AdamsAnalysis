# AA04 — Pearson Correlation
# Goal: Estimate linear association between two measurements.
# Packages: stats
# Check: Pearson r and p-value; inspect a scatterplot separately.
# Caveat: Linear association is not causal; extreme points can dominate.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

print(cor.test(d$x,d$y,method="pearson"))
