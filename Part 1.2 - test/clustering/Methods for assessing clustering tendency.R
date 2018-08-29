#Methods for assessing clustering tendency
#http://www.sthda.com/english/articles/29-cluster-validation-essentials/95-assessing-clustering-tendency-essentials/
#i) a statistical (Hopkins statistic) and 
#ii) a visual methods (Visual Assessment of cluster Tendency (VAT) algorithm).
#------------------
#Statistical methods
#1)Sample uniformly n points (p1,., pn) from D.
#2)Compute the distance, xi, from each real point to each nearest neighbor: For each point pi???D, find it's nearest neighbor pj; then compute the distance between pi and pj and denote it as xi=dist(pi,pj)
#3)Generate a simulated data set (randomD) drawn from a random uniform distribution with n points (q1,., qn) and the same variation as the original real data set D.
#4)Compute the distance, yi from each artificial point to the nearest real data point: For each point qi???randomD, find it's nearest neighbor qj in D; then compute the distance between qi and qj and denote it yi=dist(qi,qj)
#5)Calculate the Hopkins statistic (H) as the mean nearest neighbor distance in the random data set divided by the sum of the mean nearest neighbor distances in the real and across the simulated data set.
#A value for H higher than 0.75 indicates a clustering tendency at the 90% confidence level.
#Null hypothesis: the data set D is uniformly distributed (i.e., no meaningful clusters)
#Alternative hypothesis: the data set D is not uniformly distributed (i.e., contains meaningful clusters)
#RESULT::We can conduct the Hopkins Statistic test iteratively, using 0.5 as the threshold to reject the alternative hypothesis. That is, if H < 0.5, then it is unlikely that D has statistically significant clusters.
#        Put in other words, If the value of Hopkins statistic is close to 1, then we can reject the null hypothesis and conclude that the dataset D is significantly a clusterable data.
head(iris, 3)
df <- iris[, -5]
library(factoextra)
# Compute Hopkins statistic for iris dataset
res <- get_clust_tendency(df, n = nrow(df)-1, graph = FALSE)
res$hopkins_stat
# Compute Hopkins statistic for a random dataset
res <- get_clust_tendency(random_df, n = nrow(random_df)-1,
                          graph = FALSE)
res$hopkins_stat
# RESULT::It can be seen that the iris data set is highly clusterable (the H value = 0.82 which is far above the threshold 0.5). However the random_df data set is not clusterable (H = 0.47)
#---------------------
#VISUAL METHOD
#The algorithm of the visual assessment of cluster tendency (VAT) approach
#1)Compute the dissimilarity (DM) matrix between the objects in the data set using the Euclidean distance measure
#2)Reorder the DM so that similar objects are close to one another. This process create an ordered dissimilarity matrix (ODM)
#3)The ODM is displayed as an ordered dissimilarity image (ODI), which is the visual output of VAT
#For the visual assessment of clustering tendency, we start by computing the dissimilarity matrix between observations using the function dist(). Next the function fviz_dist() [factoextra package] is used to display the dissimilarity matrix.
fviz_dist(dist(df), show_labels = FALSE)+
  labs(title = "Iris data")
fviz_dist(dist(random_df), show_labels = FALSE)+
  labs(title = "Random data")
#RESULT::The dissimilarity matrix image confirms that there is a cluster structure in the iris data set but not in the random one.
