# AA21 — Multiple Linear Regression
# Goal: Estimate adjusted slopes for several predictors and evaluate prediction error.
# Packages: stats
# Check: Coefficients, intervals, and held-out MSE.
# Caveat: Correlated predictors complicate attribution; training fit is not out-of-sample accuracy.

set.seed(2026)
n <- 300
x1<-rnorm(n); x2<-rnorm(n); x3<-rnorm(n)
y<-3 + 2*x1 - x2 + 0.7*x3 + rnorm(n,sd=1.5)
d<-data.frame(y,x1,x2,x3)
idx<-sample(seq_len(n),round(.7*n))
train<-d[idx,];test<-d[-idx,]

fit<-lm(y~x1+x2+x3,data=train)
print(summary(fit))
print(mean((predict(fit,newdata=test)-test$y)^2))
