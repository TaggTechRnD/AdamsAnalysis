# AA45 — Zero-Inflated Regression
# Goal: Fit distinct processes for zero inflation and positive count intensity.
# Packages: pscl
# Check: Inflation and count-part coefficients.
# Caveat: Check whether a separate zero-generating process is theoretically justified; optimization can be unstable.

set.seed(2026)
n <- 280
x <- rnorm(n)
exposure <- runif(n, 0.5, 2)
mu <- exp(0.5 + 0.6*x + log(exposure))
y <- rpois(n, lambda = mu)
d <- data.frame(y, x, exposure)

set.seed(2027)
d$y[runif(nrow(d)) < .4] <- 0L
fit<-pscl::zeroinfl(y~x|x,data=d,dist="poisson")
print(summary(fit))
