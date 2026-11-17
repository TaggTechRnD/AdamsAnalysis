# AA52 — Confirmatory Factor Analysis (CFA)
# Goal: Confirm a prespecified two-factor measurement model.
# Packages: lavaan
# Check: Standardized loadings and global model fit statistics.
# Caveat: Good global fit alone does not establish measurement validity; check identification and residuals.

set.seed(2026)
n <- 240
f1 <- rnorm(n); f2 <- 0.3*f1 + rnorm(n)
d <- data.frame(
  a1=0.9*f1+rnorm(n,sd=.5), a2=0.8*f1+rnorm(n,sd=.6),
  a3=0.7*f1+rnorm(n,sd=.6), b1=0.9*f2+rnorm(n,sd=.5),
  b2=0.8*f2+rnorm(n,sd=.6), b3=0.7*f2+rnorm(n,sd=.6))

model <- 'F1 =~ a1 + a2 + a3
F2 =~ b1 + b2 + b3'
fit <- lavaan::cfa(model,data=d,std.lv=TRUE)
print(lavaan::fitMeasures(fit,c("cfi","tli","rmsea","srmr")))
print(lavaan::standardizedSolution(fit))
