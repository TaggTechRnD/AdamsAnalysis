# AA50 — Kaplan-Meier Analysis
# Goal: Estimate event-free probability over time by treatment arm.
# Packages: survival
# Check: Kaplan–Meier survival estimates at specific times.
# Caveat: Requires non-informative censoring for conventional interpretation.

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

fit<-survival::survfit(survival::Surv(time,event)~treatment,data=d)
print(summary(fit,times=c(5,10)))
