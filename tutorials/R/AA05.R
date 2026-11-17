# AA05 — Spearman Correlation
# Goal: Estimate monotonic association based on ranks.
# Packages: stats
# Check: Spearman rho and p-value.
# Caveat: A monotonic trend is not necessarily linear or causal.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

print(cor.test(d$x,d$y,method="spearman",exact=FALSE))
