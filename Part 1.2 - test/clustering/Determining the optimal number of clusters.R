#Determining the optimal number of clusters
#----------------------------------------
#In the R code below, we'll use the NbClust R package, which provides 30 indices for determining the best number of clusters
set.seed(123)
# Compute
install.packages("NbClust")
library("NbClust")
res.nbclust <- USArrests %>%
  scale() %>%
  NbClust(distance = "euclidean",
          min.nc = 2, max.nc = 10, 
          method = "complete", index ="all")
# Visualize
library(factoextra)
fviz_nbclust(res.nbclust, ggtheme = theme_minimal())
#--------------
# Standardize the data
df <- scale(USArrests)
head(df)
#=================================================
#fviz_nbclust() function: Elbow, Silhouhette and Gap statistic methods
#fviz_nbclust(x, FUNcluster, method = c("silhouette", "wss", "gap_stat"))
#x: numeric matrix or data frame
#FUNcluster: a partitioning function. Allowed values include kmeans, pam, clara and hcut (for hierarchical clustering).
#method: the method to be used for determining the optimal number of clusters.
#-----------
# Elbow method
fviz_nbclust(df, kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2)+
  labs(subtitle = "Elbow method")
# Silhouette method
fviz_nbclust(df, kmeans, method = "silhouette")+
  labs(subtitle = "Silhouette method")
# Gap statistic
# nboot = 50 to keep the function speedy. 
# recommended value: nboot= 500 for your analysis.
# Use verbose = FALSE to hide computing progression.
set.seed(123)
fviz_nbclust(df, kmeans, nstart = 25,  method = "gap_stat", nboot = 50)+
  labs(subtitle = "Gap statistic method")
#RESULT::Elbow method: 4 clusters solution suggested
#        Silhouette method: 2 clusters solution suggested
#        Gap statistic method: 4 clusters solution suggested
#NOTES::The disadvantage of elbow and average silhouette methods is that, they measure a global clustering characteristic only. A more sophisticated method is to use the gap statistic which provides a statistical procedure to formalize the elbow/silhouette heuristic in order to estimate the optimal number of clusters.
#=======================================
#NbClust() function: 30 indices for choosing the best number of clusters
#NbClust(data = NULL, diss = NULL, distance = "euclidean",min.nc = 2, max.nc = 15, method = NULL)
#data: matrix
#diss: dissimilarity matrix to be used. By default, diss=NULL, but if it is replaced by a dissimilarity matrix, distance should be "NULL"
#distance: the distance measure to be used to compute the dissimilarity matrix. Possible values include "euclidean", "manhattan" or "NULL".
#min.nc, max.nc: minimal and maximal number of clusters, respectively
#method: The cluster analysis method to be used including "ward.D", "ward.D2", "single", "complete", "average", "kmeans" and more.
#To compute NbClust() for kmeans, use method = "kmeans".
#To compute NbClust() for hierarchical clustering, method should be one of c("ward.D", "ward.D2", "single", "complete", "average").
library("NbClust")
nb <- NbClust(df, distance = "euclidean", min.nc = 2,
              max.nc = 10, method = "kmeans")
library("factoextra")
fviz_nbclust(nb)
#2 proposed 0 as the best number of clusters
#10 indices proposed 2 as the best number of clusters.
#2 proposed 3 as the best number of clusters.
#8 proposed 4 as the best number of clusters.
#According to the majority rule, the best number of clusters is 2.
