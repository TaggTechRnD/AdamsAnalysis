# AA61 — Gradient Boosting
# Goal: Classify disease outcomes using boosted decision trees.
# Packages: gbm
# Check: Holdout confusion matrix or AUC; inspect calibration.
# Caveat: R and Python boosting implementations differ; model selection needs validation beyond a single holdout.

set.seed(2026)
n <- 300
x1 <- rnorm(n); x2 <- rnorm(n); x3 <- rnorm(n)
p <- plogis(-.2 + 1.2*x1 - .8*x2 + .5*x3)
y <- factor(rbinom(n,1,p),levels=c(0,1),labels=c("No","Yes"))
d <- data.frame(x1,x2,x3,y)
idx <- sample(seq_len(n), size=round(.7*n))
train <- d[idx,]; test <- d[-idx,]

train$binary<-as.integer(train$y=="Yes")
fit<-gbm::gbm(binary~x1+x2+x3,data=train,distribution="bernoulli",
              n.trees=150,interaction.depth=2,shrinkage=.05,
              bag.fraction=.7,train.fraction=1,verbose=FALSE)
prob<-predict(fit,newdata=test,n.trees=150,type="response")
print(table(truth=test$y,predicted=ifelse(prob>=.5,"Yes","No")))
