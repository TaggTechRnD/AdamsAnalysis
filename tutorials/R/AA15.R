# AA15 — ANCOVA
# Goal: Compare group means while adjusting for a continuous baseline covariate.
# Packages: stats
# Check: Adjusted group coefficient and CI.
# Caveat: Check slope homogeneity by considering a group×covariate term; adjustment alone does not remove confounding.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

fit<-lm(y ~ group + x,data=d)
print(summary(fit))
print(anova(fit))
