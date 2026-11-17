# AA51 — Log-Rank Test
# Goal: Compare event-time curves between treatment arms.
# Packages: survival
# Check: Log-rank chi-square statistic and p-value.
# Caveat: Censoring assumptions and crossing hazards affect interpretation.

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

print(survival::survdiff(survival::Surv(time,event)~treatment,data=d))
