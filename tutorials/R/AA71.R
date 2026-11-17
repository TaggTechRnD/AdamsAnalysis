# AA71 — DBSCAN
# Goal: Detect density-connected clusters and possible noise points.
# Packages: dbscan
# Check: Cluster labels and number of unassigned/noise points.
# Caveat: Distance scale, epsilon and minimum-neighbor settings govern results.

set.seed(2026)
X <- rbind(matrix(rnorm(120, mean=-2, sd=.5), ncol=2),
           matrix(rnorm(120, mean=2, sd=.5), ncol=2),
           cbind(rnorm(60,mean=2,sd=.5),rnorm(60,mean=-2,sd=.5)))
colnames(X)<-c("feature1","feature2")

fit<-dbscan::dbscan(scale(X),eps=.5,minPts=5)
print(table(fit$cluster)) # 0 denotes noise
