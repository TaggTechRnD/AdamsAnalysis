# AA54 — Structural Equation Modeling (SEM)
# Goal: Fit a structural relationship between two measured latent constructs.
# Packages: lavaan
# Check: Latent regression slope, standardized loadings and fit indices.
# Caveat: Equivalent covariance patterns can have different causal explanations.

set.seed(2026)
n <- 240
f1 <- rnorm(n); f2 <- 0.3*f1 + rnorm(n)
d <- data.frame(
  a1=0.9*f1+rnorm(n,sd=.5), a2=0.8*f1+rnorm(n,sd=.6),
  a3=0.7*f1+rnorm(n,sd=.6), b1=0.9*f2+rnorm(n,sd=.5),
  b2=0.8*f2+rnorm(n,sd=.6), b3=0.7*f2+rnorm(n,sd=.6))

model <- 'F1 =~ a1+a2+a3
F2 =~ b1+b2+b3
F2 ~ F1'
fit <- lavaan::sem(model,data=d,std.lv=TRUE)
print(lavaan::fitMeasures(fit,c("cfi","rmsea","srmr")))
print(lavaan::standardizedSolution(fit))
