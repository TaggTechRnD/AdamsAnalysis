# AA18 — Chi-Square Test of Independence
# Goal: Evaluate association between two categorical variables.
# Packages: stats
# Check: Observed/expected counts and Pearson chi-square test.
# Caveat: Review expected counts; chi-square does not quantify effect magnitude.

set.seed(2026)
n <- 280
x <- rnorm(n)
treatment <- rbinom(n, 1, 0.5)
p <- plogis(-0.5 + 0.8*x - 0.7*treatment)
y <- rbinom(n, 1, p)
d <- data.frame(y, x, treatment)

ct<-table(d$treatment,d$y)
print(ct)
print(chisq.test(ct))
