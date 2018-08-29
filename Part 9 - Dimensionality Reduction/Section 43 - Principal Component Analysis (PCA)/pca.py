# PCA
#it is one feature extraction technique.
#we dont consider dependent variable that is why it is unsupervised model
# it will extract one which have most variance in detaset therefore we can reduce no of independent variable.
#it is basically classification problem it which ,here we will use logestic regression model  and will apply PCA in classification


# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
#----------------------------problem
#dependent variable is customer_segment which have three type of wine and each wine corresponding to each customer
#each independent variable have different type of chemical for three type of customer
#we can not visulize lot of independent variable at once so we will apply dimensionlaity to limited variable which can explain maximum variance.
#----------------------------

# -------------Importing the dataset
#http://archive.ics.uci.edu/ml/datasets/wine   dataset information
dataset = pd.read_csv('Wine.csv')
X = dataset.iloc[:, 0:13].values
y = dataset.iloc[:, 13].values

# -----------Splitting the dataset into the Training set and Test set
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 0)

# --------------Feature Scaling
#scaling must be apply when we are using dimensionality
from sklearn.preprocessing import StandardScaler
sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)

# -------------Applying PCA
#pca = PCA(n_components = None) run with None then choose which explain most(sum too)
#PCA must apply after data preprocessing and before fitting the model in regression.
from sklearn.decomposition import PCA
pca = PCA(n_components = 2)#extracted feature you want to get that explain most variance.
#put n_components = None because first we need to look cumulative explain variance of different principal component
X_train = pca.fit_transform(X_train)
X_test = pca.transform(X_test)
explained_variance = pca.explained_variance_ratio_#explain percentage of variance explained by each of principal component that extracted here.
#outcome of above is not original but it new created variable that explain percentage of variance
#if include 1 then 37% explained and include 2 then total 57% explained ,similarly other and last explain least variance
#for 2 component put n_components=2 which explain 57% variance i.e good.
#after that reset console because X_train,X_test are not original because extracted from transform data but we want 2 column from original dataset  so reset console i.e restart kernals then after select everything above from dimensiality code and followed by run.
#RESULLT::select 2 column explain maximum variance

# -------------Fitting Logistic Regression to the Training set
from sklearn.linear_model import LogisticRegression
classifier = LogisticRegression(random_state = 0)
classifier.fit(X_train, y_train)

# Predicting the Test set results
y_pred = classifier.predict(X_test)

# Making the Confusion Matrix
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)
#diagonal present correct result
#accuracy(sum_diagonal_element/total no)

# Visualising the Training set results
from matplotlib.colors import ListedColormap
X_set, y_set = X_train, y_train
X1, X2 = np.meshgrid(np.arange(start = X_set[:, 0].min() - 1, stop = X_set[:, 0].max() + 1, step = 0.01),
                     np.arange(start = X_set[:, 1].min() - 1, stop = X_set[:, 1].max() + 1, step = 0.01),)
plt.contourf(X1, X2, classifier.predict(np.array([X1.ravel(), X2.ravel()]).T).reshape(X1.shape),
             alpha = 0.75, cmap = ListedColormap(('red', 'green', 'blue')))
plt.xlim(X1.min(), X1.max())
plt.ylim(X2.min(), X2.max())
for i, j in enumerate(np.unique(y_set)):
    plt.scatter(X_set[y_set == j, 0], X_set[y_set == j, 1],
                c = ListedColormap(('red', 'green', 'blue'))(i), label = j)
plt.title('Logistic Regression (Training set)')
plt.xlabel('PC1')
plt.ylabel('PC2')
plt.legend()
plt.show()

# Visualising the Test set results
from matplotlib.colors import ListedColormap
X_set, y_set = X_test, y_test
X1, X2 = np.meshgrid(np.arange(start = X_set[:, 0].min() - 1, stop = X_set[:, 0].max() + 1, step = 0.01),
                     np.arange(start = X_set[:, 1].min() - 1, stop = X_set[:, 1].max() + 1, step = 0.01))
plt.contourf(X1, X2, classifier.predict(np.array([X1.ravel(), X2.ravel()]).T).reshape(X1.shape),
             alpha = 0.75, cmap = ListedColormap(('red', 'green', 'blue')))
plt.xlim(X1.min(), X1.max())
plt.ylim(X2.min(), X2.max())
for i, j in enumerate(np.unique(y_set)):
    plt.scatter(X_set[y_set == j, 0], X_set[y_set == j, 1],
                c = ListedColormap(('red', 'green', 'blue'))(i), label = j)
plt.title('Logistic Regression (Test set)')
plt.xlabel('PC1')
plt.ylabel('PC2')
plt.legend()
plt.show()