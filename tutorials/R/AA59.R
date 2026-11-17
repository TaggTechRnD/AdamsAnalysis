# AA59 — Interrupted Time Series
# Goal: Model level and slope changes at a known intervention date.
# Packages: lmtest, sandwich
# Check: Post-intervention level change and change in slope.
# Caveat: A segmented regression alone cannot exclude contemporaneous confounding; serial correlation must be checked.

set.seed(2026)
n<-180
t<-seq_len(n)
y<-20 + .04*t + 2*sin(2*pi*t/12) + as.numeric(arima.sim(list(ar=.5),n=n,sd=1.5))
d<-data.frame(t,y)

d$post<-as.integer(d$t>=100)
d$since<-pmax(0,d$t-99)
d$y<-d$y+2*d$post+.1*d$since
fit<-lm(y~t+post+since+sin(2*pi*t/12)+cos(2*pi*t/12),data=d)
print(lmtest::coeftest(fit,vcov.=sandwich::NeweyWest(fit,lag=12,prewhite=FALSE)))
