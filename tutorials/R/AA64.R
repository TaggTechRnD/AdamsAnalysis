# AA64 — Elastic Net Regression
# Goal: Combine L1 and L2 coefficient penalties.
# Packages: glmnet
# Check: Selected penalty and coefficient shrinkage.
# Caveat: The R glmnet and sklearn penalty parameterizations are not numerically identical.

set.seed(2026)
n <- 300
x1<-rnorm(n); x2<-rnorm(n); x3<-rnorm(n)
y<-3 + 2*x1 - x2 + 0.7*x3 + rnorm(n,sd=1.5)
d<-data.frame(y,x1,x2,x3)
idx<-sample(seq_len(n),round(.7*n))
train<-d[idx,];test<-d[-idx,]

fit<-glmnet::cv.glmnet(as.matrix(train[c("x1","x2","x3")]),train$y,
                       alpha=.5,nfolds=5)
print(coef(fit,s="lambda.min"))
