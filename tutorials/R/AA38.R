# AA38 — MANOVA
# Goal: Test whether independent groups differ on multiple continuous outcomes jointly.
# Packages: stats
# Check: Pillai trace or other multivariate statistic.
# Caveat: Check multivariate outliers and dependence; multivariate significance is not specific to one outcome.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

set.seed(2027)
d$y2<-5+.7*d$x+0.6*(d$group=="Treatment")+rnorm(nrow(d))
fit<-manova(cbind(y,y2)~group,data=d)
print(summary(fit,test="Pillai"))
