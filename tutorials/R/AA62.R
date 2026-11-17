# AA62 — Ridge Regression
# Goal: Shrink correlated predictor coefficients using ridge penalization.
# Packages: glmnet
# Check: Cross-validated penalty and test MSE.
# Caveat: Regularization improves prediction but does not make coefficients causal.

set.seed(2026)
n <- 300
x1<-rnorm(n); x2<-rnorm(n); x3<-rnorm(n)
y<-3 + 2*x1 - x2 + 0.7*x3 + rnorm(n,sd=1.5)
d<-data.frame(y,x1,x2,x3)
idx<-sample(seq_len(n),round(.7*n))
train<-d[idx,];test<-d[-idx,]

X<-as.matrix(train[c("x1","x2","x3")])
fit<-glmnet::cv.glmnet(X,train$y,alpha=0,nfolds=5)
p<-as.numeric(predict(fit,s="lambda.min",newx=as.matrix(test[c("x1","x2","x3")])))
print(mean((p-test$y)^2))
