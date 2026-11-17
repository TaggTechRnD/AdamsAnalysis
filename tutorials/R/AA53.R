# AA53 — Path Analysis
# Goal: Estimate prespecified observed-variable directional regression paths.
# Packages: lavaan
# Check: Direct path coefficients, uncertainty and fit.
# Caveat: Arrows express modeled hypotheses, not proof of causal direction.

set.seed(2026)
n <- 240
f1 <- rnorm(n); f2 <- 0.3*f1 + rnorm(n)
d <- data.frame(
  a1=0.9*f1+rnorm(n,sd=.5), a2=0.8*f1+rnorm(n,sd=.6),
  a3=0.7*f1+rnorm(n,sd=.6), b1=0.9*f2+rnorm(n,sd=.5),
  b2=0.8*f2+rnorm(n,sd=.6), b3=0.7*f2+rnorm(n,sd=.6))

model <- 'a2 ~ a1
b1 ~ a1 + a2'
fit <- lavaan::sem(model,data=d)
print(lavaan::parameterEstimates(fit,standardized=TRUE))
