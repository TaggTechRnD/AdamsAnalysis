# AA42 — Multinomial Logistic Regression
# Goal: Model an unordered outcome with three categories.
# Packages: nnet
# Check: Category-specific log-odds relative to reference class.
# Caveat: This simulated construction has ordered categories; use the multinomial estimator as if labels were nominal.

set.seed(2026)
n <- 280
x <- rnorm(n)
treatment <- rbinom(n, 1, 0.5)
p <- plogis(-0.5 + 0.8*x - 0.7*treatment)
y <- rbinom(n, 1, p)
d <- data.frame(y, x, treatment)

set.seed(2027)
score<-0.8*d$x-0.4*d$treatment+rnorm(nrow(d))
d$category<-factor(cut(score,breaks=c(-Inf,-.5,.5,Inf),labels=c("Low","Mid","High")))
fit<-nnet::multinom(category~x+treatment,data=d,trace=FALSE)
print(summary(fit))
