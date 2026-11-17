# AA14 — Mixed-Design ANOVA
# Goal: Evaluate whether treatment and control groups change differently over visits.
# Packages: afex
# Check: Group × time interaction, F statistic, partial eta-squared; check corrections.
# Caveat: Requires subject IDs, independent groups, complete/balanced visits for this example; a significant interaction alone is not proof of causality.

set.seed(2026)
n <- 90
d <- expand.grid(id = seq_len(n), time = factor(c("Baseline","Week6","Week12"),
                 levels=c("Baseline","Week6","Week12")))
d$group <- factor(ifelse(d$id <= n/2, "Control", "Treatment"))
subject_effect <- rnorm(n, sd = 3)
d$y <- 30 + subject_effect[d$id] + 1.2*(as.integer(d$time)-1) +
  2*(d$group == "Treatment")*(as.integer(d$time)-1) + rnorm(nrow(d), sd=2)

# Install optional dependency beforehand: install.packages("afex")
fit<-afex::aov_ez(id="id",dv="y",data=d,between="group",within="time")
print(fit)
