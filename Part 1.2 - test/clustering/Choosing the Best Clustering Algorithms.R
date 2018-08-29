#Choosing the Best Clustering Algorithms
#compare simultaneously multiple clustering algorithms in a single function call for identifying the best clustering approach and the optimal number of clusters.
#==========================================================
#Compare clustering algorithms in R
#clValid() [in the clValid package], which simplified format is as follow
install.packages("clValid")
library(clValid)
#clValid(obj, nClust, clMethods = "hierarchical", validation = "stability", maxitems = 600, metric = "euclidean", method = "average")
#We start by cluster internal measures, which include the connectivity, silhouette width and Dunn index. It's possible to compute simultaneously these internal measures for multiple clustering algorithms in combination with a range of cluster numbers.
library(clValid)
# Iris data set:
# - Remove Species column and scale
df <- scale(iris[, -5])
# Compute clValid
#Internal measures
clmethods <- c("hierarchical","kmeans","pam")
intern <- clValid(df, nClust = 2:6, 
                  clMethods = clmethods, validation = "internal")
# Summary
summary(intern)
#result::It can be seen that hierarchical clustering with two clusters performs the best in each case (i.e., for connectivity, Dunn and Silhouette measures).
#        Regardless of the clustering algorithm, the optimal number of clusters seems to be two using the three measures.
# Stability measures
clmethods <- c("hierarchical","kmeans","pam")
stab <- clValid(df, nClust = 2:6, clMethods = clmethods, 
                validation = "stability")
# Display only optimal Scores
optimalScores(stab)
#result::For the APN and ADM measures, hierarchical clustering with two clusters again gives the best score. For the other measures, PAM with six clusters has the best score.
