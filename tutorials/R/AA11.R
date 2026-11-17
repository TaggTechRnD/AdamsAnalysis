# AA11 — One-Way ANOVA
# Goal: Compare means across independent group levels.
# Packages: stats
# Check: Between-group F statistic and p-value.
# Caveat: Check independent units, variance pattern, and residuals.

set.seed(2026)
d <- expand.grid(group = factor(c("Control","Treatment")),
                 dose = factor(c("Low","High")), rep = seq_len(40))
d$y <- 10 + 2*(d$group == "Treatment") + 1*(d$dose == "High") +
  2*(d$group == "Treatment")*(d$dose == "High") + rnorm(nrow(d), sd = 2)

fit<-aov(y ~ group,data=d)
print(summary(fit))
