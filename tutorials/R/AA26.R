# AA26 — Principal Component Analysis (PCA)
# Goal: Find orthogonal directions explaining variability in standardized indicators.
# Packages: stats
# Check: Explained-variance ratios and loadings.
# Caveat: Component directions are descriptive; PCA does not prove latent constructs.

set.seed(2026)
n <- 240
f1 <- rnorm(n); f2 <- 0.3*f1 + rnorm(n)
d <- data.frame(
  a1=0.9*f1+rnorm(n,sd=.5), a2=0.8*f1+rnorm(n,sd=.6),
  a3=0.7*f1+rnorm(n,sd=.6), b1=0.9*f2+rnorm(n,sd=.5),
  b2=0.8*f2+rnorm(n,sd=.6), b3=0.7*f2+rnorm(n,sd=.6))

fit<-prcomp(d,center=TRUE,scale.=TRUE)
print(summary(fit))
print(fit$rotation)
