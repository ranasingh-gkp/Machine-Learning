# Simple Linear Regression
#  simple linear regression library take care of feature scaling
"""

Created on Sat Mar 10 17:53:16 2018

@author: Ami Laddani
"""
#Simple Linear Regression
import numpy
import matplotlib.pyplot as plt
import pandas
#import data
dataset = pandas.read_csv('Salary_Data.csv')
x= dataset.iloc[:,:-1].values
y= dataset.iloc[:,1].values

# Splitting the Dataset into the Training set and Test set
from sklearn.cross_validation import train_test_split
x_train,x_test,y_train,y_test= train_test_split(x,y, test_size= 1/3 , random_state=0)#random use so everyone have same value
#feature scale scaling
#  simple linear regression take care of feature scaling
"""from sklearn.preprocessing import StandardScaler
sc_x= StandardScaler()
x_train= sc_x.fit_transform(x_train)
x_test= sc_x.transform(x_test)"""
#(no need of scaling because library will take care of that)

#fitting simple linear regression to training set
from sklearn.linear_model import LinearRegression
regressor = LinearRegression()
regressor.fit(x_train,y_train)  # fit method use to fit data in regressor function
# predicting the test set results
y_pred = regressor.predict(x_test)  #predict method use to predict data in regression function

#visulation the training set results
plt.scatter(x_train, y_train, color= 'red')
plt.plot(x_train, regressor.predict(x_train), color='blue')
plt.title('salary vs experience(training set)')
plt.xlabel('year of exp')
plt.ylabel('salary')
plt.show()
#visulation the test set results
plt.scatter(x_test, y_test, color= 'red')
plt.plot(x_train, regressor.predict(x_train), color='blue')
plt.title('salary vs experience(test set)')
plt.xlabel('year of exp')
plt.ylabel('salary')
plt.show()
