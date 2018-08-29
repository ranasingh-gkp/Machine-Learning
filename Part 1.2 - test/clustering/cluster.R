#cluster
#http://www.sthda.com/english/articles/25-cluster-analysis-in-r-practical-guide/111-types-of-clustering-methods-overview-and-quick-start-r-code/
#------------------------------------
#we start by presenting required R packages and data format for cluster analysis and visualization.
#next, we describe the two standard clustering techniques [partitioning methods (k-MEANS, PAM, CLARA) and hierarchical clustering] as well as how to assess the quality of clustering analysis.
#finally, we describe advanced clustering approaches to find pattern of any shape in large data sets with noise and outliers.
#-----------------------------------------------
install.packages("factoextra")
install.packages("cluster")
install.packages("magrittr")
library("cluster")
library("factoextra")
library("magrittr")
# Load  and prepare the data
data("USArrests")
my_data <- USArrests %>%
  na.omit() %>%          # Remove missing values (NA)
  scale()                # Scale variables
# View the firt 3 rows
head(my_data, n = 3)
#-----------------------------------------------------------------------------------
#distance measure
#get_dist(): for computing a distance matrix between the rows of a data matrix. Compared to the standard dist() function, it supports correlation-based distance measures including "pearson", "kendall" and "spearman" methods.
#fviz_dist(): for visualizing a distance matrix
res.dist <- get_dist(USArrests, stand = TRUE, method = "pearson")
fviz_dist(res.dist,gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))
#Pearson correlation analysis is the most commonly used method. It is also known as a parametric correlation which depends on the distribution of the data.
#Kendall and Spearman correlations are non-parametric and they are used to perform rank-based correlation analysis.
#--------------
#Computing euclidean distance
dist.eucl <- dist(USArrests, method = "euclidean")
dist.eucl
#Note that, allowed values for the option method include one of: "euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski".
#you can reformat the distance vector into a matrix using the as.matrix() function.
# Reformat as a matrix
# Subset the first 3 columns and rows and Round the values
round(as.matrix(dist.eucl)[1:3, 1:3], 1)
#---------------
#Computing correlation based distances
#The function get_dist()[factoextra package] can be used to compute correlation-based distances. Correlation method can be either pearson, spearman or kendall.
# Compute
library("factoextra")
dist.cor <- get_dist(USArrests, method = "pearson")
# Display a subset
round(as.matrix(dist.cor)[1:3, 1:3], 1)
#-----------------
#Computing distances for mixed data
#The function daisy() [cluster package] provides a solution (Gower's metric) for computing the distance matrix, in the situation where the data contain no-numeric columns.
#The R code below applies the daisy() function on flower data which contains factor, ordered and numeric variables
library(cluster)
# Load data
data(flower)
head(flower, 3)
# Data structure
str(flower)
# Distance matrix
dd <- daisy(flower)
round(as.matrix(dd)[1:3, 1:3], 2)
#============================================================================================
#-----------------------------------------------------------
#Partitioning clustering
#Partitioning algorithms are clustering techniques that subdivide the data sets into a set of k groups, where k is the number of groups pre-specified by the analyst.
#each cluster is represented by the center or means of the data points belonging to the cluster. The K-means method is sensitive to outliers.
library("factoextra")
fviz_nbclust(my_data, kmeans, method = "gap_stat")
#Suggested number of cluster: 3
#-------------
# k-means clustering:
# It require to pre-specify the number of clusters to be generated.
#kmeans(x, centers, iter.max = 10, nstart = 1)
#x: numeric matrix, numeric data frame or a numeric vector
#centers: Possible values are the number of clusters (k) or a set of initial (distinct) cluster centers. If a number, a random set of (distinct) rows in x is chosen as the initial centers.
#iter.max: The maximum number of iterations allowed. Default value is 10.
#nstart: The number of random starting partitions when centers is a number. Trying nstart > 1 is often recommended.
install.packages("factoextra")
library(factoextra)
#The location of a bend (knee) in the plot is generally considered as an indicator of the appropriate number of clusters.
library(factoextra)
fviz_nbclust(df, kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2)
# Compute k-means with k = 4
set.seed(123)
km.res <- kmeans(df, 4, nstart = 25)
#nstart = 25. This means that R will try 25 different random starting assignments and then select the best results corresponding to the one with the lowest within cluster variation.
#strongly recommended to compute k-means clustering with a large value of nstart such as 25 or 50, in order to have a more stable result.
# Print the results
print(km.res)
#It's possible to compute the mean of each variables by clusters using the original data:
aggregate(USArrests, by=list(cluster=km.res$cluster), mean)
#add the point classifications to the original data,
dd <- cbind(USArrests, cluster = km.res$cluster)
head(dd)
#Accessing to the results of kmeans() function
# Cluster number for each of the observations
km.res$cluster
head(km.res$cluster, 4)
# Cluster size
km.res$size
# Cluster means
km.res$centers
#Visualizing k-means clusters
fviz_cluster(km.res, data = df,
             palette = c("#2E9FDF", "#00AFBB", "#E7B800", "#FC4E07"), 
             ellipse.type = "euclid", # Concentration ellipse
             star.plot = TRUE, # Add segments from centroids to items
             repel = TRUE, # Avoid label overplotting (slow)
             ggtheme = theme_minimal()
)
#To avoid distortions caused by excessive outliers, it's possible to use PAM algorithm, which is less sensitive to outliers.
#-----with another data
set.seed(123)
km.res <- kmeans(my_data, 3, nstart = 25)
# Visualize
library("factoextra")
fviz_cluster(km.res, data = my_data, 
             ellipse.type = "convex",
             palette = "jco",
             repel = TRUE,
             ggtheme = theme_minimal())
# visualize  PAM
library("cluster")
pam.res <- pam(my_data, 4)
# Visualize
fviz_cluster(pam.res)
#--------------------------------------

#-----------------------------------------------------------
#Hierarchical clustering
#Hierarchical clustering is an alternative approach to partitioning clustering for identifying groups in the dataset. It does not require to pre-specify the number of clusters to be generated.
#The result of hierarchical clustering is a tree-based representation of the objects, which is also known as dendrogram. Observations can be subdivided into groups by cutting the dendrogram at a desired similarity level.
# Compute hierarchical clustering
res.hc <- USArrests %>%
  scale() %>%                    # Scale the data
  dist(method = "euclidean") %>% # Compute dissimilarity matrix
  hclust(method = "ward.D2")     # Compute hierachical clustering
# Visualize using factoextra
# Cut in 4 groups and color by groups
fviz_dend(res.hc, k = 4, # Cut in four groups
          cex = 0.5, # label size
          k_colors = c("#2E9FDF", "#00AFBB", "#E7B800", "#FC4E07"),
          color_labels_by_k = TRUE, # color labels by groups
          rect = TRUE # Add rectangle around groups
)
#==========================================================================
#Advanced clustering methods
#------------------
#Hybrid clustering methods
df <- scale(USArrests)
# Compute hierarchical k-means clustering
library(factoextra)
res.hk <-hkmeans(df, 4)
# Elements returned by hkmeans()
names(res.hk)
# Print the results
res.hk
# Visualize the tree
fviz_dend(res.hk, cex = 0.6, palette = "jco",rect = TRUE, rect_border = "jco", rect_fill = TRUE)
# Visualize the hkmeans final clusters
fviz_cluster(res.hk, palette = "jco", repel = TRUE, ggtheme = theme_classic())
#--------------------------
#Fuzzy clustering
#In Fuzzy clustering, items can be a member of more than one cluster. Each item has a set of membership coefficients corresponding to the degree of being in a given cluster. The Fuzzy c-means method is the most popular fuzzy clustering algorithm.
#x: A data matrix or data frame or dissimilarity matrix
#k: The desired number of clusters to be generated
#metric: Metric for calculating dissimilarities between observations
#stand: If TRUE, variables are standardized before calculating the dissimilarities
library(cluster)
df <- scale(USArrests)     # Standardize the data
res.fanny <- fanny(df, 2)  # Compute fuzzy clustering with k = 2
head(res.fanny$membership, 3) # Membership coefficients
res.fanny$coeff # Dunn's partition coefficient
head(res.fanny$clustering) # Observation groups
library(factoextra)
fviz_cluster(res.fanny, ellipse.type = "norm", repel = TRUE,
             palette = "jco", ggtheme = theme_minimal(),
             legend = "right")
#To evaluate the goodnesss of the clustering results, plot the silhouette coefficient as follow:
fviz_silhouette(res.fanny, palette = "jco",ggtheme = theme_minimal())
#NOTE::Fuzzy clustering is an alternative to k-means clustering, where each data point has membership coefficient to each cluster
#--------------------------------------
#Model-based clustering
#An alternative is model-based clustering, which consider the data as coming from a distribution that is mixture of two or more clusters
#Unlike k-means, the model-based clustering uses a soft assignment, where each data point has a probability of belonging to each cluster.
# Load the data
library("MASS")
data("geyser")
geyser
# Scatter plot
library("ggpubr")
ggscatter(geyser, x = "duration", y = "waiting")+
  geom_density2d() # Add 2D density
#we might anticipate that the three components of this mixture might have homogeneous covariance matrices.
#Choosing the best model::The best model is selected using the Bayesian Information Criterion or BIC. A large BIC score indicates strong evidence for the corresponding model.
#                         The Mclust package uses maximum likelihood to fit all these models, with different covariance matrix parameterizations, for a range of k components.
install.packages("mclust")
library(mclust)
data("diabetes")
head(diabetes, 3)
#Model-based clustering can be computed using the function Mclust() as follow:
df <- scale(diabetes[, -1]) # Standardize the data
mc <- Mclust(df)            # Model-based-clustering
summary(mc)                 # Print a summary
#infer::For this data, it can be seen that model-based clustering selected a model with three components (i.e. clusters).
#       The optimal selected model name is VVV model. That is the three components are ellipsoidal with varying volume, shape, and orientation

#You can access to the results as follow:
mc$modelName                # Optimal selected model ==> "VVV"
mc$G                        # Optimal number of cluster => 3
head(mc$z, 30)              # Probality to belong to a given cluster
head(mc$classification, 30) # Cluster assignement of each observation
#Visualizing model-based clustering
#The first two principal components are used to produce a scatter plot of the data.
#if you want to plot the data using only two variables of interest, let say here c("insulin", "sspg"), you can specify that in the fviz_mclust() function using the argument choose.vars = c("insulin", "sspg").
library(factoextra)
# BIC values used for choosing the number of clusters
fviz_mclust(mc, "BIC", palette = "jco")
# Classification: plot showing the clustering
fviz_mclust(mc, "classification", geom = "point", 
            pointsize = 1.5, palette = "jco")
# Classification uncertainty
fviz_mclust(mc, "uncertainty", palette = "jco")
# in the uncertainty plot, larger symbols indicate the more uncertain observations.
#------------------------------------------------------
#Density-based clustering
#http://www.sthda.com/english/articles/30-advanced-clustering/105-dbscan-density-based-clustering-essentials/
#Partitioning methods (K-means, PAM clustering) and hierarchical clustering are suitable for finding spherical-shaped clusters or convex clusters.
#In other words, they work well only for compact and well separated clusters. Moreover, they are also severely affected by the presence of noise and outliers in the data.
#Unfortunately, real life data can contain: i) clusters of arbitrary shape such as those shown in the figure below (oval, linear and "S" shape clusters); ii) many outliers and noise.
install.packages("factoextra")
library(factoextra)
data("multishapes")
multishapes
df <- multishapes[, 1:2]
#first,compute and visualize k-means clustering using the data set multishapes.
set.seed(123)
km.res <- kmeans(df, 5, nstart = 25)
fviz_cluster(km.res, df,  geom = "point", 
             ellipse= FALSE, show.clust.cent = FALSE,
             palette = "jco", ggtheme = theme_classic())
#We know there are 5 five clusters in the data, but it can be seen that k-means method inaccurately identify the 5 clusters.
install.packages("fpc")
install.packages("dbscan")
install.packages("factoextra")
# Load the data 
data("multishapes", package = "factoextra")
df <- multishapes[, 1:2]
# Compute DBSCAN using fpc package
library("fpc")
set.seed(123)
db <- fpc::dbscan(df, eps = 0.15, MinPts = 5)
# Plot DBSCAN results
library("factoextra")
fviz_cluster(db, data = df, stand = FALSE,
             ellipse = FALSE, show.clust.cent = FALSE,
             geom = "point",palette = "jco", ggtheme = theme_classic())
#It can be seen that DBSCAN performs better for these data sets and can identify the correct set of clusters compared to k-means algorithms.
#NOTE::function fviz_cluster() uses different point symbols for core points (i.e, seed points) and border points. Black points correspond to outliers. You can play with eps and MinPts for changing cluster configurations.
#result of the fpc::dbscan() function can be displayed as follow:
print(db)
# Cluster 0 corresponds to outliers (black points in the DBSCAN plot). 
#The function print.dbscan() shows a statistic of the number of points belonging to the clusters that are seeds and border points.
# Cluster membership. Noise/outlier observations are coded as 0
# A random subset is shown
db$cluster[sample(1:1089, 20)]

#Method for determining the optimal eps value
#The function kNNdistplot() [in dbscan package] can be used to draw the k-distance plot:
dbscan::kNNdistplot(df, k =  5)
abline(h = 0.15, lty = 2)
#It can be seen that the optimal eps value is around a distance of 0.15.

#============================================================================================
#Clustering validation and evaluation
#Clustering validation and evaluation strategies, consist of measuring the goodness of clustering results.
#Before applying any clustering algorithm to a data set, the first thing to do is to assess the clustering tendency. That is, whether the data contains any inherent grouping structure.
#If yes, then how many clusters are there. Next, you can perform hierarchical clustering or partitioning clustering (with a pre-specified number of clusters). Finally, you can use a number of measures, described in this chapter, to evaluate the goodness of the clustering results.
#-----------------------
#1)Assessing clustering tendency
#To assess the clustering tendency, the Hopkins' statistic and a visual approach can be used. 
#This can be performed using the function get_clust_tendency() [factoextra package], which creates an ordered dissimilarity image (ODI).
#Hopkins statistic: If the value of Hopkins statistic is close to 1 (far above 0.5), then we can conclude that the dataset is significantly clusterable.
#Visual approach: The visual approach detects the clustering tendency by counting the number of square shaped dark (or colored) blocks along the diagonal in the ordered dissimilarity image.
install.packages(c("factoextra", "clustertend"))
head(iris, 3)
# Iris data set
df <- iris[, -5]
# Random data generated from the iris data set
random_df <- apply(df, 2, 
                   function(x){runif(length(x), min(x), (max(x)))})
random_df <- as.data.frame(random_df)
random_df
# Standardize the data sets
df <- iris.scaled <- scale(df)
random_df <- scale(random_df)
#visulization
#1)
gradient.color <- list(low = "steelblue",  high = "white")
iris[, -5] %>%    # Remove column 5 (Species)
  scale() %>%     # Scale variables
  get_clust_tendency(n = 50, gradient = gradient.color)
#2)
#As the data contain more than two variables, we need to reduce the dimensionality in order to plot a scatter plot. This can be done using principal component analysis (PCA) algorithm (R function: prcomp()).
library("factoextra")
# Plot faithful data set
fviz_pca_ind(prcomp(df), title = "PCA - Iris data", 
             habillage = iris$Species,  palette = "jco",
             geom = "point", ggtheme = theme_classic(),
             legend = "bottom")
# Plot the random df
fviz_pca_ind(prcomp(random_df), title = "PCA - Random data", 
             geom = "point", ggtheme = theme_classic())
#result::It can be seen that the iris data set contains 3 real clusters. However the randomly generated data set doesn't contain any meaningful clusters
#Why assessing clustering tendency?
#In order to illustrate why it's important to assess cluster tendency, we start by computing k-means clustering (Chapter @ref(kmeans-clustering)) and hierarchical clustering (Chapter @ref(agglomerative-clustering)) on the two data sets (the real and the random data)
#The function fviz_cluster() and fviz_dend() [in factoextra R package] will be used to visualize the results.
library(factoextra)
set.seed(123)
# K-means on iris dataset
km.res1 <- kmeans(df, 3)
fviz_cluster(list(data = df, cluster = km.res1$cluster),
             ellipse.type = "norm", geom = "point", stand = FALSE,
             palette = "jco", ggtheme = theme_classic())
# K-means on the random dataset
km.res2 <- kmeans(random_df, 3)
fviz_cluster(list(data = random_df, cluster = km.res2$cluster),
             ellipse.type = "norm", geom = "point", stand = FALSE,
             palette = "jco", ggtheme = theme_classic())
# Hierarchical clustering on the random dataset
fviz_dend(hclust(dist(random_df)), k = 3, k_colors = "jco",  
          as.ggplot = TRUE, show_labels = FALSE)
#result::It can be seen that the k-means algorithm and the hierarchical clustering impose a classification on the random uniformly distributed data set even if there are no meaningful clusters present in it. This is why, clustering tendency assessment methods should be used to evaluate the validity of clustering analysis. That is, whether a given data set contains meaningful clusters.

