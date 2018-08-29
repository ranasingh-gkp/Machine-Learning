# Self Organizing Map
#IT CONVERT MANY COLUMN INTO 2-d MAP

# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Importing the dataset
#http://archive.ics.uci.edu/ml/datasets/statlog+(australian+credit+approval)
#in this problem to detect the approval of credit card application
#here outlier are the faulty neurons which should not be approved
#here we will calculate mean interneuron distance(MID) i.e mean of euclian distance between study neuron and neighbourhood so we can detect outlier which will be far from the nieghbour neuron on basis of euclian distance
dataset = pd.read_csv('Credit_Card_Applications.csv')
X = dataset.iloc[:, :-1].values
y = dataset.iloc[:, -1].values
#here will only use X in training set because doing unsuperwise deep learning// we are telling customer eligibility, not predicting classes. so no dependent variable considered.

# Feature Scaling(between 0 & 1)
#compulsary for deep learning so high computation
from sklearn.preprocessing import MinMaxScaler
sc = MinMaxScaler(feature_range = (0, 1))
X = sc.fit_transform(X)

# -------Training the SOM
#here we are using MiniSom 1.0
#https://test.pypi.org/project/MiniSom/1.0/
#here in your working directory , we need to keep Minisom 1.0.py file downloaded created by developer in working directory. 
from minisom import MiniSom
som = MiniSom(x = 10, y = 10, input_len = 15, sigma = 1.0, learning_rate = 0.5)#object som trained on X//   X & y are dimension of SOM(MORE THE DATA i.e no of CUSTOMER more will be dimension)///  here input_len is the no of feature in training dataset i.e X(14) and +1 for customer id 
som.random_weights_init(X)#sigma is the radious of different neighbourhood i.e default value is 1.0//  learning_rate will decide how much weight updated in each learning rate so  default value is 0.5 so higher will be the learning_rate faster will be convergence, lower the learning_rate, longer the self organising map take time to build.//  decay_function can be use to improve convergence
som.train_random(data = X, num_iteration = 100)#num_iteration is no of time it need to repeate
#random_weights_init IS THE method initialize the weight mention by developer i.e by Minisom1.0
#train_random method use to train 


# ---------Visualizing the results
#here we will calculate mean interneuron distance(MID) i.e mean of euclian distance between study neuron and neighbourhood so we can detect outlier which will be far from the nieghbour neuron on basis of euclian distance
#larger the mid closer to white in colour
from pylab import bone, pcolor, colorbar, plot, show#BUILDING self organising map
bone()#initlizee the figure i.e window contain map
pcolor(som.distance_map().T)#use different colour for different MID///   distance_map WILL RETURN ALL mid IN MAPS.//  ".T" will take transpose of MID matrics
colorbar()# that is legend for all colour
markers = ['o', 's']# 'o', 's' circle and squire as markers
colors = ['r', 'g']# red circle if customer did not get approval and green squire if customer got approval
for i, x in enumerate(X): # enumerate(X) all vector of customer in all iteration
    w = som.winner(x)#  winner get winning nodes of all customer
    plot(w[0] + 0.5,  #adding markers and color in each winner nodes
         w[1] + 0.5,  #0.5 to put at centre of marker
         markers[y[i]],  #if y[i] is 0 then marker[0] correspond to circle with red color
         markeredgecolor = colors[y[i]],
         markerfacecolor = 'None',   #markerfacecolor tell that inside color of marker is non
         markersize = 10,
         markeredgewidth = 2)
show()

# Finding the frauds
mappings = som.win_map(X)#win_map use to get dictionary
frauds = np.concatenate((mappings[(8,1)], mappings[(3,8)]), axis = 0)# take outlier cordinate of "Visualizing the results" section//  concatenate function use to concatenate these two customer in one list
frauds = sc.inverse_transform(frauds)# axis = 0 means concatenate aling vertical axis i.e customer put below to other
#inverse_transform use to reverse scaling


# ==========Part 2 - Going from Unsupervised to Supervised Deep Learning

# Creating the matrix of features
customers = dataset.iloc[:, 1:].values#all column from index 1 to last one

# Creating the dependent variable
#is_fraud is dependent variable
is_fraud = np.zeros(len(dataset))#vector initialize eith zero 690
for i in range(len(dataset)):# loop it if cusatomer id match with froud then replace 0 with 1 in is_fraud dependent variable
    if dataset.iloc[i,0] in frauds:# ith customer of first column match with fraud id
        is_fraud[i] = 1#replace

# Feature Scaling
from sklearn.preprocessing import StandardScaler
sc = StandardScaler()
customers = sc.fit_transform(customers)

# ------Part 2 - Now let's make the ANN!

# Importing the Keras libraries and packages
from keras.models import Sequential
from keras.layers import Dense

# Initialising the ANN
classifier = Sequential()

# Adding the input layer and the first hidden layer
classifier.add(Dense(units = 2, kernel_initializer = 'uniform', activation = 'relu', input_dim = 15))

# Adding the output layer
classifier.add(Dense(units = 1, kernel_initializer = 'uniform', activation = 'sigmoid'))

# Compiling the ANN
classifier.compile(optimizer = 'adam', loss = 'binary_crossentropy', metrics = ['accuracy'])

# Fitting the ANN to the Training set
classifier.fit(customers, is_fraud, batch_size = 1, epochs = 2)# batch_size = 1, epochs = 2 use because have less data

# Predicting the probabilities of frauds
y_pred = classifier.predict(customers)
y_pred = np.concatenate((dataset.iloc[:, 0:1].values, y_pred), axis = 1)#concatenate dataset.iloc[:, 0:1].values is customer id,  and y_pred row wise(axis = 1) 
y_pred = y_pred[y_pred[:, 1].argsort()]# sorting probability
#second column(y_pred[:, 1) is going to sort
#argsort() sort the arrar of column index 1
#here we use 0:1 to make customer id 2-D array in concatenate because y_pred id 2-D matrix and customer id dataset.iloc[:, 0] have 1-D array so 
