# AA24 — Linear Mixed-Effects Model
# Goal: Fit correlated repeated measurements using a random participant intercept.
# Packages: lme4
# Check: Fixed group/time/interaction effects and random intercept variance.
# Caveat: Random-effects structure and missingness assumptions require checking.

set.seed(2026)
n <- 90
d <- expand.grid(id = seq_len(n), time = factor(c("Baseline","Week6","Week12"),
                 levels=c("Baseline","Week6","Week12")))
d$group <- factor(ifelse(d$id <= n/2, "Control", "Treatment"))
subject_effect <- rnorm(n, sd = 3)
d$y <- 30 + subject_effect[d$id] + 1.2*(as.integer(d$time)-1) +
  2*(d$group == "Treatment")*(as.integer(d$time)-1) + rnorm(nrow(d), sd=2)

fit<-lme4::lmer(y~group*time+(1|id),data=d,REML=FALSE)
print(summary(fit))
