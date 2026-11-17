# AA65 — Support Vector Machine (SVM)
# Goal: Learn a nonlinear decision boundary with a support-vector machine.
# Packages: e1071
# Check: Test accuracy/confusion and sensitivity to hyperparameters.
# Caveat: Scale predictors and tune C/gamma before deployment; outputs are not calibrated probabilities.

set.seed(2026)
n <- 300
x1 <- rnorm(n); x2 <- rnorm(n); x3 <- rnorm(n)
p <- plogis(-.2 + 1.2*x1 - .8*x2 + .5*x3)
y <- factor(rbinom(n,1,p),levels=c(0,1),labels=c("No","Yes"))
d <- data.frame(x1,x2,x3,y)
idx <- sample(seq_len(n), size=round(.7*n))
train <- d[idx,]; test <- d[-idx,]

fit<-e1071::svm(y~x1+x2+x3,data=train,kernel="radial",cost=1)
p<-predict(fit,test)
print(table(truth=test$y,predicted=p))
