# AA57 — ARIMA
# Goal: Fit a seasonal ARIMA model and forecast six periods.
# Packages: stats
# Check: Model coefficients, forecast and residual autocorrelation.
# Caveat: Choose order based on diagnostics, not arbitrary default; avoid look-ahead leakage.

set.seed(2026)
n<-180
t<-seq_len(n)
y<-20 + .04*t + 2*sin(2*pi*t/12) + as.numeric(arima.sim(list(ar=.5),n=n,sd=1.5))
d<-data.frame(t,y)

series<-ts(d$y,frequency=12)
fit<-arima(series,order=c(1,1,1),seasonal=list(order=c(0,1,1),period=12))
print(fit)
print(predict(fit,n.ahead=6)$pred)
