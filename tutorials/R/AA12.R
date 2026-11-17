# AA12 — Two-Way ANOVA
# Goal: Estimate main and interaction effects of two between-person factors.
# Packages: stats
# Check: Group-by-dose interaction F test.
# Caveat: Interpret interaction before interpreting marginal main effects.

set.seed(2026)
d <- expand.grid(group = factor(c("Control","Treatment")),
                 dose = factor(c("Low","High")), rep = seq_len(40))
d$y <- 10 + 2*(d$group == "Treatment") + 1*(d$dose == "High") +
  2*(d$group == "Treatment")*(d$dose == "High") + rnorm(nrow(d), sd = 2)

fit<-aov(y ~ group*dose,data=d)
print(summary(fit))
