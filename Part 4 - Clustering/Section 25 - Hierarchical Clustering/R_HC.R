# Hierarchical Clustering
#agglomerative cluster::every time reducing one by making it one cluster, finally it reduced to one
#purpose is each memory stored in dendogram..at each step, height of dendogram is euclenian distance
#how dendogram work::https://www.youtube.com/watch?v=7Nw_wsCi3MM&index=119&list=PLclhPfG31KRExnNovDGE-ipPpKp9nRe2V
#
# Importing the dataset
dataset = read.csv('Mall_Customers.csv')
dataset = dataset[4:5]# include more column if have

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

# Using the dendrogram to find the optimal number of clusters
dendrogram = hclust(d = dist(dataset, method = 'euclidean'), method = 'ward.D')#ward minimise variance in each cluster
plot(dendrogram,
     main = paste('Dendrogram'),
     xlab = 'Customers',
     ylab = 'Euclidean distances')
#in dendrogram, find longest vertical line which not crossing any horizontal line, then draw a horizontal line through longest line, count the crossing line
#find 5 cluser

# Fitting Hierarchical Clustering to the dataset
hc = hclust(d = dist(dataset, method = 'euclidean'), method = 'ward.D')
y_hc = cutree(hc, 5)

# Visualising the clusters
library(cluster)
clusplot(dataset,
         y_hc,
         lines = 0,
         shade = TRUE,
         color = TRUE,
         labels= 2,
         plotchar = FALSE,
         span = TRUE,
         main = paste('Clusters of customers'),
         xlab = 'Annual Income',
         ylab = 'Spending Score')
#later we will use dimension reduction concept to use above 2-D formate ploting