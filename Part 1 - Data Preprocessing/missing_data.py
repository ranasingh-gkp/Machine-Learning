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
#it is better replace missing data  by means or medion or friquent data ..removing causes information loss
from sklearn.preprocessing import Imputer  #library
imputer = Imputer(missing_values = 'NaN', strategy = 'mean', axis = 0)  # axis 1(row), 0(column)..here column fitting is better at missing position
imputer = imputer.fit(X[:, 1:3])  #fitting missing value  by means columnwise
X[:, 1:3] = imputer.transform(X[:, 1:3])  #transform data by means of that column




























