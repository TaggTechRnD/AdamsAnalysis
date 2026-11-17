# AA25 — Generalized Linear Mixed Model (GLMM)
# Goal: Model binary outcomes clustered within participants.
# Packages: lme4
# Check: Conditional fixed effects and between-person heterogeneity.
# Caveat: Python uses a Bayesian variational fit; numerical estimates and uncertainty differ from frequentist lme4.

set.seed(2026)
n <- 280
x <- rnorm(n)
treatment <- rbinom(n, 1, 0.5)
p <- plogis(-0.5 + 0.8*x - 0.7*treatment)
y <- rbinom(n, 1, p)
d <- data.frame(y, x, treatment)

set.seed(2026)
d$id<-rep(seq_len(70),each=4)
d$subject<-rnorm(70)[d$id]
d$y<-rbinom(nrow(d),1,plogis(-.5+.8*d$x+.6*d$subject))
fit<-lme4::glmer(y~x+(1|id),data=d,family=binomial())
print(summary(fit))
