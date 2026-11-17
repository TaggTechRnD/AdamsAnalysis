# AA48 — Generalized Estimating Equations (GEE)
# Goal: Estimate population-average effects for clustered binary outcomes.
# Packages: geepack
# Check: Marginal coefficients and robust uncertainty.
# Caveat: GEE requires sufficient independent clusters; working correlation is a modeling choice.

set.seed(2026)
n <- 280
x <- rnorm(n)
treatment <- rbinom(n, 1, 0.5)
p <- plogis(-0.5 + 0.8*x - 0.7*treatment)
y <- rbinom(n, 1, p)
d <- data.frame(y, x, treatment)

set.seed(2027)
d$id<-rep(seq_len(70),each=4)
d$y<-rbinom(nrow(d),1,plogis(-.3+.7*d$x+rnorm(70)[d$id]*.3))
fit<-geepack::geeglm(y~x+treatment,id=id,data=d,
                     family=binomial(),corstr="exchangeable")
print(summary(fit))
