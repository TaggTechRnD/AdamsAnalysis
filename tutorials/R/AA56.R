# AA56 — Latent Growth Curve Modeling
# Goal: Represent repeated outcomes via latent intercept and linear change factors.
# Packages: lavaan
# Check: Mean and variation of growth factors, where estimated.
# Caveat: Growth identification and mean structure require special care; semopy Model does not exactly replicate lavaan::growth.

set.seed(2026)
n <- 90
d <- expand.grid(id = seq_len(n), time = factor(c("Baseline","Week6","Week12"),
                 levels=c("Baseline","Week6","Week12")))
d$group <- factor(ifelse(d$id <= n/2, "Control", "Treatment"))
subject_effect <- rnorm(n, sd = 3)
d$y <- 30 + subject_effect[d$id] + 1.2*(as.integer(d$time)-1) +
  2*(d$group == "Treatment")*(as.integer(d$time)-1) + rnorm(nrow(d), sd=2)

wide<-reshape(d[,c("id","time","y")],idvar="id",timevar="time",direction="wide")
names(wide)<-sub("y[.]","y_",names(wide))
model <- 'i =~ 1*y_Baseline + 1*y_Week6 + 1*y_Week12
  s =~ 0*y_Baseline + 1*y_Week6 + 2*y_Week12
  i ~~ s'
fit<-lavaan::growth(model,data=wide)
print(lavaan::parameterEstimates(fit))
