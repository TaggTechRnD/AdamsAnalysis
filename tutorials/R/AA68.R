# AA68 — Artificial Neural Network
# Goal: Classify binary outcomes using a small feed-forward neural network.
# Packages: nnet
# Check: Holdout accuracy and convergence diagnostics.
# Caveat: Training is stochastic and sensitive to scaling, early stopping and model capacity.

set.seed(2026)
n <- 300
x1 <- rnorm(n); x2 <- rnorm(n); x3 <- rnorm(n)
p <- plogis(-.2 + 1.2*x1 - .8*x2 + .5*x3)
y <- factor(rbinom(n,1,p),levels=c(0,1),labels=c("No","Yes"))
d <- data.frame(x1,x2,x3,y)
idx <- sample(seq_len(n), size=round(.7*n))
train <- d[idx,]; test <- d[-idx,]

fit<-nnet::nnet(y~x1+x2+x3,data=train,size=4,decay=.01,
                maxit=300,trace=FALSE)
p<-predict(fit,test,type="class")
print(table(truth=test$y,predicted=p))
