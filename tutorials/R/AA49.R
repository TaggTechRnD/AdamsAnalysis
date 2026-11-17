# AA49 — Cox Proportional Hazards Regression
# Goal: Model covariate effects on the hazard of an event.
# Packages: survival
# Check: Hazard ratios and CIs; check proportional hazards.
# Caveat: A hazard ratio is not a risk ratio or a difference in mean survival time.

set.seed(2026)
n <- 250
x <- rnorm(n)
treatment <- rbinom(n, 1, 0.5)
rate <- 0.08*exp(0.5*x - 0.5*treatment)
true_time <- rexp(n, rate=rate)
censor_time <- runif(n, 5, 22)
time <- pmin(true_time, censor_time)
event <- as.integer(true_time <= censor_time)
d <- data.frame(time, event, x, treatment)

fit<-survival::coxph(survival::Surv(time,event)~x+treatment,data=d)
print(summary(fit))
