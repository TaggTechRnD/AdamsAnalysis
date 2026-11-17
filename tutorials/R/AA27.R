# AA27 — Exploratory Factor Analysis (EFA)
# Goal: Explore a two-factor measurement structure.
# Packages: stats
# Check: Rotated item loadings and uniquenesses.
# Caveat: Factor count and rotation are substantive choices; factor labels are interpretive.

set.seed(2026)
n <- 240
f1 <- rnorm(n); f2 <- 0.3*f1 + rnorm(n)
d <- data.frame(
  a1=0.9*f1+rnorm(n,sd=.5), a2=0.8*f1+rnorm(n,sd=.6),
  a3=0.7*f1+rnorm(n,sd=.6), b1=0.9*f2+rnorm(n,sd=.5),
  b2=0.8*f2+rnorm(n,sd=.6), b3=0.7*f2+rnorm(n,sd=.6))

fit<-factanal(d,factors=2,rotation="varimax")
print(fit)
