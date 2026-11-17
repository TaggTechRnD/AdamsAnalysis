# AA69 — K-Means Clustering
# Goal: Partition unlabeled cases into three compact clusters.
# Packages: stats
# Check: Cluster sizes, within-cluster sum of squares.
# Caveat: Number of clusters is specified, not inferred; no inherent p-value.

set.seed(2026)
X <- rbind(matrix(rnorm(120, mean=-2, sd=.5), ncol=2),
           matrix(rnorm(120, mean=2, sd=.5), ncol=2),
           cbind(rnorm(60,mean=2,sd=.5),rnorm(60,mean=-2,sd=.5)))
colnames(X)<-c("feature1","feature2")

fit<-kmeans(scale(X),centers=3,nstart=20)
print(table(fit$cluster))
print(fit$tot.withinss)
