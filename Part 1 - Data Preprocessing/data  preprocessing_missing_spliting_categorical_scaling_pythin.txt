#data preprocessing
"""
Spyder Editor

This is a temporary script file.
"""
import numpy
import matplotlib.pyplot
import pandas
dataset = pandas.read_csv('Data.csv')
x= dataset.iloc[:,:-1].values   #.iloc[] is primarily integer position based selection
y= dataset.iloc[:,3].values
x= dataset.iloc[:,:-1].values
#take care of missing data
#it is better replace missing data  by means or medion or friquent data ..removing causes information loss
from sklearn.preprocessing import Imputer  # importing library
imputer= Imputer(missing_values = 'NaN', strategy='mean', axis=0)   # axis 1(row), 0(column)..here column fitting is better at missing position
imputer = imputer.fit(x[:,1:3])   #fitting missing value  by means columnwise
x[:,1:3]= imputer.transform(x[:,1:3])  #transform data by means of that column
# catogerical data
#two column contain categorical data which contain category
#here we will convvert categorical varaible into number
from sklearn.preprocessing import LabelEncoder, OneHotEncoder    #library import LabelEncoder(use for encoding categorical variable in one column), OneHotEncoder use for convert different categorivcal into different column
labelencoder_x = LabelEncoder()   #call LabelEncoder class
x[:,0]=labelencoder_x.fit_transform(x[:,0])    #fit_transform method , we can not compart 0,1,2 as one is greater then other because there are categorical variable
onehotencoder= OneHotEncoder(categorical_features = [0])   #calling OneHotEncoder
x= onehotencoder.fit_transform(x).toarray() #  for independent variable
labelencoder_y = LabelEncoder()   #since it is dependent variable having one column , python encode it as 0,1
y =labelencoder_y.fit_transform(y)   #for dependent variable
# Splitting the Dataset into the Training set and Test set
from sklearn.cross_validation import train_test_split
x_train,x_test,y_train,y_test= train_test_split(x,y, test_size=0.3, random_state=0)
#feature scale scaling
#machine learning depend upon eucleian distance so there must bbe scaling between different variabel(age,,salary)
from sklearn.preprocessing import StandardScaler
sc_x= StandardScaler()  #(standardization, normalization) method 
x_train= sc_x.fit_transform(x_train)# first fit in above function then transform it
x_test= sc_x.transform(x_test)
#scaling dummy variiable depend , what type  of data we have, we can scale dummy variable in order to increase accuracy but they can loose there identities.
# scaling will be in between -1 to +1.
#some time we use scaling in decision tree also although it's not based upon eucleian distance
#dependent variable if is in categorical variable then , no need to apply scaling but if not then we can apply



