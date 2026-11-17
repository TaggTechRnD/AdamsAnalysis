# AA17 — Friedman Test
# Goal: Compare repeated rank outcomes across three visits.
# Packages: stats
# Check: Friedman chi-square statistic and p-value.
# Caveat: Requires complete blocks in this example; follow up significant omnibus result with appropriate comparisons.

set.seed(2026)
n <- 90
d <- expand.grid(id = seq_len(n), time = factor(c("Baseline","Week6","Week12"),
                 levels=c("Baseline","Week6","Week12")))
d$group <- factor(ifelse(d$id <= n/2, "Control", "Treatment"))
subject_effect <- rnorm(n, sd = 3)
d$y <- 30 + subject_effect[d$id] + 1.2*(as.integer(d$time)-1) +
  2*(d$group == "Treatment")*(as.integer(d$time)-1) + rnorm(nrow(d), sd=2)

wide<-reshape(d[,c("id","time","y")],idvar="id",timevar="time",direction="wide")
print(friedman.test(as.matrix(wide[,grep("^y[.]",names(wide))])))
