# AA02 — Median and Interquartile Range
# Goal: Summarize the center and spread robustly.
# Packages: stats
# Check: Median, 25th and 75th percentiles; IQR = Q3 − Q1.
# Caveat: Quartiles are sample descriptions, not confidence limits.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

print(quantile(d$y,c(.25,.5,.75)))
print(IQR(d$y))
