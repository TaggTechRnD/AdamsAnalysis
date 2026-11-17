# AA01 — Mean and Standard Deviation
# Goal: Summarize a continuous health measurement.
# Packages: stats
# Check: Compare the sample mean with the SD, both in outcome units.
# Caveat: The SD is not a standard error; outliers can affect both summaries.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

print(c(mean=mean(d$y), sd=sd(d$y), n=length(d$y)))
