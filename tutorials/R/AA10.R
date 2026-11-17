# AA10 — Wilcoxon Signed-Rank Test
# Goal: Test whether paired changes are centered at zero in a signed-rank framework.
# Packages: stats
# Check: Signed-rank statistic and p-value.
# Caveat: Requires appropriate symmetry for a median-change interpretation.

set.seed(2026)
n <- 90
before <- rnorm(n, mean = 125, sd = 13)
after <- before - 5 + rnorm(n, sd = 7)
d <- data.frame(id = seq_len(n), before, after)

print(wilcox.test(d$after,d$before,paired=TRUE,exact=FALSE))
