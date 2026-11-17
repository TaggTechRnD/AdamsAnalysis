# AA31 — Cross-Tabulation
# Goal: Produce cross-tabulations and within-group proportions.
# Packages: stats
# Check: Cell counts, margins, and denominator-aware percentages.
# Caveat: A crosstab is descriptive; no causal inference is justified.

set.seed(2026)
n <- 280
x <- rnorm(n)
treatment <- rbinom(n, 1, 0.5)
p <- plogis(-0.5 + 0.8*x - 0.7*treatment)
y <- rbinom(n, 1, p)
d <- data.frame(y, x, treatment)

ct<-table(Treatment=d$treatment,Outcome=d$y)
print(addmargins(ct))
print(prop.table(ct,margin=1))
