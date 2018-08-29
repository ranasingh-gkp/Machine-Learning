# Recurrent Neural Network

# Part 1 - Data Preprocessing

# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Importing the training set
dataset_train = pd.read_csv('Google_Stock_Price_Train.csv')
training_set = dataset_train.iloc[:, 1:2].values#making seperate column for open google stock prices//(1:2) means extract column 1 but in 2-D numpay array

# Feature Scaling
from sklearn.preprocessing import MinMaxScaler#  for scaling we are applying Normilization technique
sc = MinMaxScaler(feature_range = (0, 1))
training_set_scaled = sc.fit_transform(training_set)
#at end we will reverse to get original value with object sc

#create the input and the output 
X_train = training_set[0:1257]#at time t
y_train = training_set[1:1258]#at time t+1 

#----Reshaping(to reshape into new dimension)
#https://keras.io/layers/recurrent/(input shape)
X_train = np.reshape(X_train, (1257,1,1))# (1257,1,1) first observation corresponding to observation second to timestep and third dimension corresponding to feature


# Part 2 - Building the RNN

# Importing the Keras libraries and packages
from keras.models import Sequential#initialize RNN,ANN,CNN
from keras.layers import Dense
from keras.layers import LSTM
from keras.layers import Dropout

# Initialising the RNN
regressor = Sequential()#so here is continous outcome, not categorical outcome, so we are making regression model
#classifier when predict classification model

# Adding the input layer and LSTM layer
regressor.add(LSTM(units =4, activation = 'sigmoid', input_shape = (None,  1)))
#units is member units in LSTM model
#activation function is either sigmoid or rectifier

# Adding the output layer
regressor.add(Dense(units = 1))#units correspond to no of neurons in output layer that correspond to dimension of outcomes i.e 1.
#stock price at (t+1)

# Compiling the RNN
regressor.compile(optimizer = 'adam', loss = 'mean_squared_error')
#since it is regression we use loss function as mean_squared_error in deap learning

# Fitting the RNN to the Training set
regressor.fit(X_train, y_train, epochs = 100, batch_size = 32)
#epochs should from 100-200 according to tuning

# Part 3 - Making the predictions and visualising the results

# Getting the real stock price of 2017
dataset_test = pd.read_csv('Google_Stock_Price_Test.csv')
real_stock_price = dataset_test.iloc[:, 1:2].values

# Getting the predicted stock price of 2017
inputs = real_stock_price
inputs = sc.transform(inputs)
inputs = np.reshape(inputs, (20,1,1))#20 finentiol day of january 17
predicted_stock_price = regressor.predict(inputs)
predicted_stock_price = sc.inverse_transform(predicted_stock_price)

# Visualising the results
plt.plot(real_stock_price, color = 'red', label = 'Real Google Stock Price')
plt.plot(predicted_stock_price, color = 'blue', label = 'Predicted Google Stock Price')
plt.title('Google Stock Price Prediction')
plt.xlabel('Time')
plt.ylabel('Google Stock Price')
plt.legend()
plt.show()

#homework

#getting the real stock price of 2012-2016
real_stock_price_train = pd.read_csv('Google_Stock_Price_Train.csv')
real_stock_price_train = real_stock_price_train.iloc[:, 1:2].values#making seperate column for open google stock prices//(1:2) means extract column 1 but in 2-D numpay array

#getting the predicted stock price of 2012-2016
predicted_stock_price_train = regressor.predict(X_train)
predicted_stock_price_train = sc.inverse_transform(predicted_stock_price_train)

# Visualising the results
plt.plot(real_stock_price_train, color = 'red', label = 'Real Google Stock Price')
plt.plot(predicted_stock_price_train, color = 'blue', label = 'Predicted Google Stock Price')
plt.title('Google Stock Price Prediction')
plt.xlabel('Time')
plt.ylabel('Google Stock Price')
plt.legend()
plt.show()


