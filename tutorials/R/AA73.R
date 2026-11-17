# AA73 — Distributed Lag Non-Linear Model (DLNM)
# Goal: Demonstrate a nonlinear temperature association distributed over several lags.
# Packages: dlnm
# Check: Lagged exposure-basis effects and model fit; in R, inspect cross-predictions in subsequent work.
# Caveat: Python example uses separate lag splines, NOT a smooth lag-axis crossbasis; neither example implements a full confounding-adjusted epidemiological DLNM.

set.seed(2026)
n<-180
t<-seq_len(n)
y<-20 + .04*t + 2*sin(2*pi*t/12) + as.numeric(arima.sim(list(ar=.5),n=n,sd=1.5))
d<-data.frame(t,y)

set.seed(2027)
n<-nrow(d)
temp<-20+8*sin(2*pi*d$t/30)+rnorm(n,sd=2)
lag1<-c(NA,temp[-n])
d$y<-5+.08*(temp-20)^2+.05*(lag1-20)^2+rnorm(n)
cb<-dlnm::crossbasis(temp,lag=3,
       argvar=list(fun="bs",df=4),arglag=list(fun="ns",df=3))
fit<-glm(d$y~cb+d$t,family=gaussian())
print(summary(fit)$coefficients)
