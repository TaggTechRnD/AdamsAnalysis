# AA13 — Repeated-Measures ANOVA
# Goal: Test changes over repeated visits ignoring between-group effects.
# Packages: stats
# Check: Within-person time F statistic.
# Caveat: For between-group effects or missing visits use mixed ANOVA/mixed model; sphericity matters with >2 visits.

set.seed(2026)
n <- 90
d <- expand.grid(id = seq_len(n), time = factor(c("Baseline","Week6","Week12"),
                 levels=c("Baseline","Week6","Week12")))
d$group <- factor(ifelse(d$id <= n/2, "Control", "Treatment"))
subject_effect <- rnorm(n, sd = 3)
d$y <- 30 + subject_effect[d$id] + 1.2*(as.integer(d$time)-1) +
  2*(d$group == "Treatment")*(as.integer(d$time)-1) + rnorm(nrow(d), sd=2)

d$id<-factor(d$id)
fit<-aov(y ~ time + Error(id/time),data=d)
print(summary(fit))
