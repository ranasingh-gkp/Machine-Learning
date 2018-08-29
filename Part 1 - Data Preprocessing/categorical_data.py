# Data Preprocessing

# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Importing the dataset
dataset = pd.read_csv('Data.csv')
X = dataset.iloc[:, :-1].values
y = dataset.iloc[:, 3].values

# Taking care of missing data
from sklearn.preprocessing import Imputer
imputer = Imputer(missing_values = 'NaN', strategy = 'mean', axis = 0)
imputer = imputer.fit(X[:, 1:3])
X[:, 1:3] = imputer.transform(X[:, 1:3])

# Encoding categorical data
#two column contain categorical data which contain category
#here we will convvert categorical varaible into number
# Encoding the Independent Variable
from sklearn.preprocessing import LabelEncoder, OneHotEncoder  #library import LabelEncoder(use for encoding categorical variable in one column), OneHotEncoder use for convert different categorivcal into different column
labelencoder_X = LabelEncoder()  #call LabelEncoder class
X[:, 0] = labelencoder_X.fit_transform(X[:, 0])  #fit_transform method , we can not compart 0,1,2 as one is greater then other because there are categorical variable
onehotencoder = OneHotEncoder(categorical_features = [0]) #calling OneHotEncoder
X = onehotencoder.fit_transform(X).toarray()
# Encoding the Dependent Variable
labelencoder_y = LabelEncoder()  #since it is dependent variable having one column , python encode it as 0,1
y = labelencoder_y.fit_transform(y)