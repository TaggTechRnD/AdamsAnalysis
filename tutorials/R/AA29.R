# AA29 — Random Forest
# Goal: Classify outcomes with an ensemble of trees.
# Packages: randomForest
# Check: Holdout confusion matrix and class-level performance.
# Caveat: Feature importance is not causal; tune parameters with cross-validation.

set.seed(2026)
n <- 300
x1 <- rnorm(n); x2 <- rnorm(n); x3 <- rnorm(n)
p <- plogis(-.2 + 1.2*x1 - .8*x2 + .5*x3)
y <- factor(rbinom(n,1,p),levels=c(0,1),labels=c("No","Yes"))
d <- data.frame(x1,x2,x3,y)
idx <- sample(seq_len(n), size=round(.7*n))
train <- d[idx,]; test <- d[-idx,]

fit<-randomForest::randomForest(y~x1+x2+x3,data=train,ntree=200)
p<-predict(fit,newdata=test)
print(table(truth=test$y,predicted=p))
