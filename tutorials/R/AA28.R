# AA28 — Decision Tree
# Goal: Fit an interpretable classification tree and evaluate it on holdout data.
# Packages: rpart
# Check: Confusion matrix or test accuracy and tree splits.
# Caveat: A single tree is unstable; avoid evaluating it only on the training set.

set.seed(2026)
n <- 300
x1 <- rnorm(n); x2 <- rnorm(n); x3 <- rnorm(n)
p <- plogis(-.2 + 1.2*x1 - .8*x2 + .5*x3)
y <- factor(rbinom(n,1,p),levels=c(0,1),labels=c("No","Yes"))
d <- data.frame(x1,x2,x3,y)
idx <- sample(seq_len(n), size=round(.7*n))
train <- d[idx,]; test <- d[-idx,]

fit<-rpart::rpart(y~x1+x2+x3,data=train,method="class")
p<-predict(fit,newdata=test,type="class")
print(table(truth=test$y,predicted=p))
