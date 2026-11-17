# AA58 — Exponential Smoothing (ETS)
# Goal: Model level, trend and additive seasonality using exponential smoothing.
# Packages: stats
# Check: Future values, smoothing parameters and out-of-sample errors.
# Caveat: Forecast uncertainty not illustrated; choose additive/multiplicative forms based on data.

set.seed(2026)
n<-180
t<-seq_len(n)
y<-20 + .04*t + 2*sin(2*pi*t/12) + as.numeric(arima.sim(list(ar=.5),n=n,sd=1.5))
d<-data.frame(t,y)

series<-ts(d$y,frequency=12)
fit<-HoltWinters(series,seasonal="additive")
print(predict(fit,n.ahead=6))
