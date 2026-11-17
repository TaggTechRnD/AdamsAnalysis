# AA63 — LASSO Regression
# Goal: Select/shrink predictors using the L1 penalty.
# Packages: glmnet
# Check: Nonzero coefficients, chosen penalty and holdout prediction error.
# Caveat: Variable selection may be unstable across samples; naive post-selection p-values are invalid.

set.seed(2026)
n <- 300
x1<-rnorm(n); x2<-rnorm(n); x3<-rnorm(n)
y<-3 + 2*x1 - x2 + 0.7*x3 + rnorm(n,sd=1.5)
d<-data.frame(y,x1,x2,x3)
idx<-sample(seq_len(n),round(.7*n))
train<-d[idx,];test<-d[-idx,]

X<-as.matrix(train[c("x1","x2","x3")])
fit<-glmnet::cv.glmnet(X,train$y,alpha=1,nfolds=5)
print(coef(fit,s="lambda.min"))
p<-as.numeric(predict(fit,s="lambda.min",newx=as.matrix(test[c("x1","x2","x3")])))
print(mean((p-test$y)^2))
