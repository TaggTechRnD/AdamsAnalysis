# AA66 — k-Nearest Neighbors (kNN)
# Goal: Classify a new record using nearby training observations.
# Packages: class
# Check: Holdout classification accuracy and class counts.
# Caveat: Distance metric and feature scaling strongly affect results.

set.seed(2026)
n <- 300
x1 <- rnorm(n); x2 <- rnorm(n); x3 <- rnorm(n)
p <- plogis(-.2 + 1.2*x1 - .8*x2 + .5*x3)
y <- factor(rbinom(n,1,p),levels=c(0,1),labels=c("No","Yes"))
d <- data.frame(x1,x2,x3,y)
idx <- sample(seq_len(n), size=round(.7*n))
train <- d[idx,]; test <- d[-idx,]

cols<-c("x1","x2","x3")
mu<-colMeans(train[,cols]); s<-apply(train[,cols],2,sd)
Xt<-scale(train[,cols],center=mu,scale=s)
Xv<-scale(test[,cols],center=mu,scale=s)
p<-class::knn(train=Xt,test=Xv,cl=train$y,k=7)
print(table(truth=test$y,predicted=p))
