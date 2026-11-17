# AA09 — Mann-Whitney U Test
# Goal: Compare independent rank distributions.
# Packages: stats
# Check: Mann–Whitney U/W and p-value.
# Caveat: Not generally a test of median differences unless distribution shapes support that interpretation.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

print(wilcox.test(y ~ group,data=d,exact=FALSE))
