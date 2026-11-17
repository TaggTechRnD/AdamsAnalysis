# AA72 — Isolation Forest
# Goal: Assign anomaly scores by random tree isolation.
# Packages: isotree
# Check: Highest-scoring unusual records; inspect rather than automatically delete.
# Caveat: Scoring conventions differ by library; anomalies are not necessarily data errors.

set.seed(2026)
X <- rbind(matrix(rnorm(120, mean=-2, sd=.5), ncol=2),
           matrix(rnorm(120, mean=2, sd=.5), ncol=2),
           cbind(rnorm(60,mean=2,sd=.5),rnorm(60,mean=-2,sd=.5)))
colnames(X)<-c("feature1","feature2")

fit<-isotree::isolation.forest(as.data.frame(X),ntrees=150,seed=2026)
score<-predict(fit,as.data.frame(X),type="score")
print(head(sort(score,decreasing=TRUE),10))
