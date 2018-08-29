# polynomial regression
# we dont need feature scaling for this because library will take care of that
"""
Created on Sun Mar 11 18:52:10 2018

@author: Ami Laddani
"""

# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Importing the dataset
dataset = pd.read_csv('Position_Salaries.csv')
x = dataset.iloc[:, 1:2].values
#try to avoid vector form
y = dataset.iloc[:, 2].values
#(independent variable should be in matrix form so we use 1:2 in x), 2 have no significance meaning because upper bound we do not consider in python
# Splitting the dataset into the Training set and Test set
#we will not split dataset because we have very less data
'''from sklearn.cross_validation import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 0)'''

# Feature Scaling
#scaling not require here
"""from sklearn.preprocessing import StandardScaler
sc_X = StandardScaler()
X_train = sc_X.fit_transform(X_train)
X_test = sc_X.transform(X_test)
sc_y = StandardScaler()
y_train = sc_y.fit_transform(y_train)"""

#fitting linear regression to dataset
from sklearn.linear_model import LinearRegression
lin_reg = LinearRegression()
lin_reg.fit(x, y)

#fitting polynomial regression to dataset--------------------------
from sklearn.preprocessing import PolynomialFeatures
poly_reg= PolynomialFeatures(degree =4)
#it will include variable upto fourth power of x like x0, x1, x2, x3, x4
# first constant column already included which have value 1.
x_poly = poly_reg.fit_transform(x)
#(we use fit_transform when we transfer value into some variable)
lin_reg_2 = LinearRegression()
lin_reg_2.fit(x_poly, y)
#----------------------------------------------------------
# visulizing the linear regression result
plt.scatter(x, y, color = 'red')
plt.plot(x, lin_reg.predict(x), color = 'blue')
plt.title('truth(linear  regression)')
plt.xlabel('position level')
plt.ylabel('salary')
plt.show()

#visulizing the polunomial regression result
#-----for smooth curve----
x_grid= np.arange(min(x),max(x), 0.1)# create new x called x_grid 
x_grid= x_grid.reshape(len(x_grid), 1)# reshapre into no of row and column
#------completeed griding
plt.scatter(x, y, color = 'red')
plt.plot(x_grid, lin_reg_2.predict(poly_reg.fit_transform(x_grid)), color = 'blue')# here we are using predict function
#we are using poly_reg.fit_transform(x_grid) instead of x_poly because x_poly already defined
plt.title('truth(linear  regression)')
plt.xlabel('position level')
plt.ylabel('salary')
plt.show()

#predict new result with linearl regression 
lin_reg.predict(6.5)

#prediction new result by polynomial regression
lin_reg_2.predict(poly_reg.fit_transform(6.5))