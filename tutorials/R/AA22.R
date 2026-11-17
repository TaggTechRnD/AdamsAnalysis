# AA22 — Binary Logistic Regression
# Goal: Model the probability of a binary outcome through log-odds.
# Packages: stats
# Check: Log-odds coefficients, odds ratios and uncertainty.
# Caveat: Odds ratios are not risk ratios; check separation and calibration.

set.seed(2026)
n <- 280
x <- rnorm(n)
treatment <- rbinom(n, 1, 0.5)
p <- plogis(-0.5 + 0.8*x - 0.7*treatment)
y <- rbinom(n, 1, p)
d <- data.frame(y, x, treatment)

fit<-glm(y~x+treatment,data=d,family=binomial())
print(summary(fit))
print(exp(coef(fit)))
