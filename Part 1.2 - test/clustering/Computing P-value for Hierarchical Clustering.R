#Computing P-value for Hierarchical Clustering
#----------------------------------------
#Clusters with AU >= 95% are considered to be strongly supported by data.
install.packages("pvclust")
library(pvclust)
# Load the data
data("lung")
head(lung[, 1:4])
# Dimension of the data
dim(lung)
#The R function sample() can be used to extract a random subset of 30 samples:
set.seed(123)
ss <- sample(1:73, 30) # extract 20 samples out of
df <- lung[, ss]
#Compute p-value for hierarchical clustering
#pvclust(data, method.hclust = "average",method.dist = "correlation", nboot = 1000)
#Note that, the computation time can be strongly decreased using parallel computation version called parPvclust().
#parPvclust(cl=NULL, data, method.hclust = "average", method.dist = "correlation", nboot = 1000,iseed = NULL)
#data: numeric data matrix or data frame.
#method.hclust: the agglomerative method used in hierarchical clustering. Possible values are one of "average", "ward", "single", "complete", "mcquitty", "median" or "centroid". The default is "average". See method argument in ?hclust.
#method.dist: the distance measure to be used. Possible values are one of "correlation", "uncentered", "abscor" or those which are allowed for method argument in dist() function, such "euclidean" and "manhattan".
#nboot: the number of bootstrap replications. The default is 1000.
#iseed: an integrer for random seeds. Use iseed argument to achieve reproducible results.
library(pvclust)
set.seed(123)
res.pv <- pvclust(df, method.dist="cor",method.hclust="average", nboot = 10)
# Default plot
plot(res.pv, hang = -1, cex = 0.5)
pvrect(res.pv)
#Values on the dendrogram are AU p-values (Red, left), BP values (green, right), and clusterlabels (grey, bottom). 
#Clusters with AU > = 95% are indicated by the rectangles and are considered to be strongly supported by data.
clusters <- pvpick(res.pv)
clusters
#Parallel computation can be applied as follow:
# Create a parallel socket cluster
library(parallel)
cl <- makeCluster(2, type = "PSOCK")
# parallel version of pvclust
res.pv <- parPvclust(cl, df, nboot=1000)
stopCluster(cl)
