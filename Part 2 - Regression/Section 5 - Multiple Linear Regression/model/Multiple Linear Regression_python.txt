#Multiple  Linear Regression
# we dont need feature scaling for this because library will take care of that
"""
Spyder Editor

This is a temporary script file.
"""
#-----------Multiple  Linear Regression
import numpy as np
import matplotlib.pyplot as plt
import pandas
#------------import data
dataset = pandas.read_csv('50_Startups.csv')
x= dataset.iloc[:,:-1].values
y= dataset.iloc[:,4].values
#--------------Encoding categorical data
#state actually a categorical variable, we can't add directly it to independent variable equation so we need to create a dummy variable so we have two type of category , we will create two column
# Encoding the Independent Variable
from sklearn.preprocessing import LabelEncoder, OneHotEncoder
labelencoder_X = LabelEncoder()
x[:, 3] = labelencoder_X.fit_transform(x[:, 3])
onehotencoder = OneHotEncoder(categorical_features = [3])
x = onehotencoder.fit_transform(x).toarray()
#-------------avoiding the dummy variable trap
#try to use minimum dummy variable  in model(if you have n dummy variabme then use only n-1 in model because there is some relation in between)
# So remove first column of dataset
x= x[:,1:]
# Splitting the Dataset into the Training set and Test set
from sklearn.cross_validation import train_test_split
x_train,x_test,y_train,y_test= train_test_split(x,y, test_size= 0.2 , random_state=0)#random use so everyone have same value
#--------------feature scale scaling
# we dont need feature scaling for this because library will take care of that
"""from sklearn.preprocessing import StandardScaler
sc_x= StandardScaler()
x_train= sc_x.fit_transform(x_train)
x_test= sc_x.transform(x_test)"""
#(no need of scaling because library will take care of that)
#fitting multiple linear regression to training set
from sklearn.linear_model import LinearRegression
regressor = LinearRegression()
regressor.fit(x_train,y_train)
# prediction the test set result
y_pred=regressor.predict(x_test)

# Backword elimination
import statsmodels.formula.api as sm
x= np.append(arr = np.ones((50,1)).astype(int), values = x, axis= 1)
# since in multilinear regression there is constant term at beginning so we need to add one column of array of value 1
#append function use to add  two array at end
#.astype(int) use to  convert into integer typpe to avoid anydata type error
#arr = np.ones((50,1)).astype(int) is array of 1  after that X array will be added at end
x_opt = x[:, [0,1,2,3,4,5]]
regressor_OLS= sm.OLS(endog = y, exog = x_opt).fit()#fitting OLS method in statsmodels library
regressor_OLS.summary()
#one by one we will check significance level of independent variable
#lesser  the p-value , more the impact of independent on dependent variable
x_opt = x[:, [0,1,3,4,5]]
regressor_OLS= sm.OLS(endog = y, exog = x_opt).fit()
regressor_OLS.summary()
x_opt = x[:, [0,3,4,5]]
regressor_OLS= sm.OLS(endog = y, exog = x_opt).fit()
regressor_OLS.summary()
x_opt = x[:, [0,3,5]]
regressor_OLS= sm.OLS(endog = y, exog = x_opt).fit()
regressor_OLS.summary()
x_opt = x[:, [0,3]]
regressor_OLS= sm.OLS(endog = y, exog = x_opt).fit()
regressor_OLS.summary()