# AA03 — Frequencies and Proportions
# Goal: Tabulate binary response frequencies.
# Packages: stats
# Check: Counts and sample proportions in each category.
# Caveat: Specify denominator and missing-data policy.

set.seed(2026)
n <- 280
x <- rnorm(n)
treatment <- rbinom(n, 1, 0.5)
p <- plogis(-0.5 + 0.8*x - 0.7*treatment)
y <- rbinom(n, 1, p)
d <- data.frame(y, x, treatment)

print(table(d$y))
print(prop.table(table(d$y)))
