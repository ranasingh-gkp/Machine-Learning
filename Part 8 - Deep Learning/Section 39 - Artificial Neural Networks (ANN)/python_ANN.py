# Artificial Neural Network

# Installing Theano
# pip install --upgrade --no-deps git+git://github.com/Theano/Theano.git

# Installing Tensorflow
# Install Tensorflow from the website: https://www.tensorflow.org/versions/r0.12/get_started/os_setup.html

# Installing Keras
# pip install --upgrade keras

# Part 1 - Data Preprocessing

# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Importing the dataset
dataset = pd.read_csv('Churn_Modelling.csv')
X = dataset.iloc[:, 3:13].values
y = dataset.iloc[:, 13].values

# Encoding categorical data
from sklearn.preprocessing import LabelEncoder, OneHotEncoder
labelencoder_X_1 = LabelEncoder()
X[:, 1] = labelencoder_X_1.fit_transform(X[:, 1])
labelencoder_X_2 = LabelEncoder()
X[:, 2] = labelencoder_X_2.fit_transform(X[:, 2])
onehotencoder = OneHotEncoder(categorical_features = [1])
X = onehotencoder.fit_transform(X).toarray()
X = X[:, 1:]

# Splitting the dataset into the Training set and Test set
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 0)

# Feature Scaling
from sklearn.preprocessing import StandardScaler
sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)

# Part 2 - Now let's make the ANN!

# Importing the Keras libraries and packages
import keras
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import Dropout #Improving the ANN
#--------------------------------------
#this neural network going to be a classifier so first build classifier
#we will select step function for hidden layer and sigmoid function for output layer
# Initialising the ANN
classifier = Sequential()

# Adding the input layer and the first hidden layer
classifier.add(Dense(output_dim = 6, init = 'uniform', activation = 'relu', input_dim = 11))#relu is parameter corresponding rectifier function, 11 is no of input in hidden layer i.e no of independent variable
# classifier.add(Dropout(p = 0.1))
#so 11 node in input layer and 1 node in output layer so average((11+1)/2=6) is 6
# 6 is no of node we want to add in hidden layer which specify no of input in hidden layer
#to get optimal parameter in model, we generally do parameter tuning but in above problem we will take average no of node as input in model i.e 6.
#so 11 node in input layer and 1 node in output layer so average((11+1)/2=6) is 6

# Adding the second hidden layer
classifier.add(Dense(output_dim = 6, init = 'uniform', activation = 'relu'))#initlization uniform waight that come from first layer to all
# classifier.add(Dropout(p = 0.1))
# Adding the output layer
classifier.add(Dense(output_dim = 1, init = 'uniform', activation = 'sigmoid'))#initlization uniform waight that come from second layer to all
# here we are using sigmoid function in output layer
# Compiling the ANN
classifier.compile(optimizer = 'adam', loss = 'binary_crossentropy', metrics = ['accuracy'])
#optimizer is algorithum use to find out optimal no of weight 
#sum(y-y`)^2 is the loss function in linear regression but in logistic function have different function...in case of one output we have binary_crossentropy but more then one output we will use (caterorical_crossvalidation) as loss function
# Fitting the ANN to the Training set
classifier.fit(X_train, y_train, batch_size = 10, nb_epoch = 100)#100 time train
#we need to do no of experiment to find out batch_size and nb_epoch

#------- Part 3 - Making the predictions and evaluating the model
# RESULT::so finally we rwach the accuracy of 83.5 % in created model
# Predicting the Test set results
y_pred = classifier.predict(X_test)# return the probability of customer leave the bank
# RESULT::so first customer have 23% chance to leave the bank
#FOR validation we will seek same accuracy in test data
y_pred = (y_pred > 0.5)# but we neeed yes or no
#customer 5 leave the bank
#accuracy is (no of currect/total) i.e (1536+146)/2000 ~84%

#------- Making the Confusion Matrix
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)

#we will use data mining technique to find out why customer leave the bank

# Predicting a single new observation
"""Predict if the customer with the following informations will leave the bank:
Geography: France
Credit Score: 600
Gender: Male
Age: 40
Tenure: 3
Balance: 60000
Number of Products: 2
Has Credit Card: Yes
Is Active Member: Yes
Estimated Salary: 50000"""
new_prediction = classifier.predict(sc.transform(np.array([[0.0, 0, 600, 1, 40, 3, 60000, 2, 1, 1, 50000]])))#information should put in horizontal vector, not vertical??single pair put element in column"[]" but double pair[[]] put in row. and put in same order as in dataset
new_prediction = (new_prediction > 0.5)#above sc.transform because X_test we used is in scaled.??see above method

# =============Part 4 - Evaluating, Improving and Tuning the ANN
#judging accuracy on one test is not good idea to predict model performance
#so technique k-fold cross validation is good to fix the variance problem
# k-Fold Cross Validation
#improving model performances by k-fold cross varidation
#it split training set into suppose 10 different fold(mostly take 10) which after iterate one by one on 9 fold and then test on last fold
#then take average of accuracy of different iterated and then calculate variance
#then there is tradeoff between accuracy and biased

# -----Evaluating the ANN
# k-fold cross validation
from keras.wrappers.scikit_learn import KerasClassifier
from sklearn.model_selection import cross_val_score
from keras.models import Sequential
from keras.layers import Dense
def build_classifier():   #it is articture of ANN
    classifier = Sequential()
    classifier.add(Dense(units = 6, kernel_initializer = 'uniform', activation = 'relu', input_dim = 11))
    classifier.add(Dense(units = 6, kernel_initializer = 'uniform', activation = 'relu'))
    classifier.add(Dense(units = 1, kernel_initializer = 'uniform', activation = 'sigmoid'))
    classifier.compile(optimizer = 'adam', loss = 'binary_crossentropy', metrics = ['accuracy']) #CAREFULL copy all classifier except fitting
    return classifier #this function return classifier
classifier = KerasClassifier(build_fn = build_classifier, batch_size = 10, epochs = 100)#new classifier trained with training classifier for k-fold cross validation
accuracies = cross_val_score(estimator = classifier, X = X_train, y = y_train, cv = 10, n_jobs = -1)#n_jobs = -1 to use all cpu (using different training on different training fold at same time)
mean = accuracies.mean()#to find out mean which tell overall accuracy which we got 90%
variance = accuracies.std()#find standard variance to find out variance here is not too high
#RESULT:: HERE FIND ACCURACY TABLE:: will get accuracy of all 10 fold iteration ...now we will take mean of all accuracy that give much better idea of model performances.

# ------Improving the ANN
#when overfitting happen, we get large accuracy on training set then test set.
#we can detect overfitting , if have high variance in k-fold mean test because model learn to much on training set which not fit obn test set.
# Dropout Regularization to reduce overfitting if needed
#at each iteration some neuron of ANN randomly disable to prevent them from too dependent on each other when they learn correlation and therefor by over-riding these neurons, the cANN learn several correlation in data  because each time they are not same configurartion of neurons and the fact we get several independent correlation in data ,thanks the fact that neuron work independently yhat prevent neurons learning too much that prevent overfitting.
'''
#if have overfitting you should apply dropout all the layer
#P value -first try 0.1 if still have overfitting try 0.2 then 0.3....but not more then 0.5 because underfitting
classifier.add(Dropout(P =0.1))
# above apply after each hidden layer including input layer except output layer
#example ::its already there in Initialising the ANN section.
classifier.add(Dense(units = 6, kernel_initializer = 'uniform', activation = 'relu', input_dim = 11))
classifier.add(Dropout(p = 0.1))'''

# Tuning the ANN
from keras.wrappers.scikit_learn import KerasClassifier
from sklearn.model_selection import GridSearchCV
from keras.models import Sequential
from keras.layers import Dense
def build_classifier(optimizer):  #optimizer replace adam for tunning different optimizer
    classifier = Sequential()
    classifier.add(Dense(units = 6, kernel_initializer = 'uniform', activation = 'relu', input_dim = 11))
    classifier.add(Dense(units = 6, kernel_initializer = 'uniform', activation = 'relu'))
    classifier.add(Dense(units = 1, kernel_initializer = 'uniform', activation = 'sigmoid'))
    classifier.compile(optimizer = optimizer, loss = 'binary_crossentropy', metrics = ['accuracy'])
    return classifier
classifier = KerasClassifier(build_fn = build_classifier)#batch_size = 10, epochs = 100 not mention here because we are going to tune there variable..#Tuning of ANN start here
 #dictionary of parameter that we are going to find
parameters = {'batch_size': [25, 32],  #apply different batch_size in pair
              'epochs': [100, 500],     #apply different epochs in pair
              'optimizer': ['adam', 'rmsprop']}  #rmsprop use in RNN
grid_search = GridSearchCV(estimator = classifier,   #test several combination of parameter
                           param_grid = parameters,
                           scoring = 'accuracy',
                           cv = 10)          #NO of folds
grid_search = grid_search.fit(X_train, y_train)
best_parameters = grid_search.best_params_
best_accuracy = grid_search.best_score_



#to get best accuracy try to change ANN articture and parameter values.