# AA19 — Fisher's Exact Test
# Goal: Test association in a two-by-two categorical table.
# Packages: stats
# Check: Odds ratio and exact p-value.
# Caveat: For 2×2 tables; an odds ratio is not the same as a risk ratio.

set.seed(2026)
n <- 280
x <- rnorm(n)
treatment <- rbinom(n, 1, 0.5)
p <- plogis(-0.5 + 0.8*x - 0.7*treatment)
y <- rbinom(n, 1, p)
d <- data.frame(y, x, treatment)

ct<-table(d$treatment,d$y)
print(fisher.test(ct))
