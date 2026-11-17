# AA70 — Hierarchical Clustering
# Goal: Create a hierarchy of clusters and cut at a specified level.
# Packages: stats
# Check: Ward linkage merge tree and three-group partition.
# Caveat: Linkage and scaling affect results; dendrogram proximity is not statistical significance.

set.seed(2026)
X <- rbind(matrix(rnorm(120, mean=-2, sd=.5), ncol=2),
           matrix(rnorm(120, mean=2, sd=.5), ncol=2),
           cbind(rnorm(60,mean=2,sd=.5),rnorm(60,mean=-2,sd=.5)))
colnames(X)<-c("feature1","feature2")

h<-hclust(dist(scale(X)),method="ward.D2")
print(table(cutree(h,k=3)))
