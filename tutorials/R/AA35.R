# AA35 — Partial Correlation
# Goal: Estimate the linear x–y correlation after adjusting for group.
# Packages: stats
# Check: Partial correlation coefficient; note residualization.
# Caveat: For formal inference accounting for control variables, adjust degrees of freedom (naive residual correlation p-value does not).

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

# Residualize y and x against an observed covariate: group
rx<-resid(lm(x~group,data=d))
ry<-resid(lm(y~group,data=d))
r<-cor(rx,ry); df<-length(rx)-3
stat<-r*sqrt(df/(1-r^2))
print(c(partial_r=r, df=df, p_value=2*pt(-abs(stat),df=df)))
