# K-Means Clustering

# Importing the dataset
dataset = read.csv('Mall_Customers.csv')
#spending score computed based upon the several criteria like no of time visit, amount spend etc
x = dataset[4:5]

# Splitting the dataset into the Training set and Test set
# install.packages('caTools')
# library(caTools)
# set.seed(123)
# split = sample.split(dataset$DependentVariable, SplitRatio = 0.8)
# training_set = subset(dataset, split == TRUE)
# test_set = subset(dataset, split == FALSE)

# Feature Scaling
# training_set = scale(training_set)
# test_set = scale(test_set)



#before using k-mean, we need to specify no of cluster so The Elbow Method use to calculate no of cluster
# Using the elbow method to find the optimal number of clusters
set.seed(6)#(in order to get same result)
wcss = vector()
for (i in 1:10) wcss[i] = sum(kmeans(x, i)$withinss)
plot(1:10,
     wcss,
     type = 'b',  #b for both,,point and line
     main = paste('The Elbow Method'),
     xlab = 'Number of clusters',
     ylab = 'WCSS')
#when graph moving substantial to non-substantial , that point os optimal no of cluster
#we got  k-5 cluster

# Fitting K-Means to the dataset
set.seed(29)
kmeans = kmeans(x, centers = 5)
y_kmeans = kmeans$cluster
kmeans
y_kmeans
# Visualising the clusters
library(cluster)
clusplot(x,
         y_kmeans,
         lines = 0,
         shade = TRUE,
         color = TRUE,
         labels = 2,
         plotchar = FALSE,
         span = TRUE,
         main = paste('Clusters of customers'),
         xlab = 'Annual Income',
         ylab = 'Spending Score')
#above graph is only for 2-D, we can use dimension reduction to use above graph