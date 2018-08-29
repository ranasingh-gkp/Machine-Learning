# Simple Linear Regression
#  simple linear regression library take care of feature scaling
#--------------------------------------
dataset = read.csv("Salary_Data.csv")

#Splitting the Dataset into the Training set and Test set
#install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(dataset$Salary, SplitRatio = 2/3)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)
#feature scale scaling
#training_set[,2:3]=scale(training_set[,2:3])
#test_set[,2:3]=scale(test_set[,2:3])
#fitting simple linear regression to training set
regressor= lm(formula = Salary ~ YearsExperience, data = training_set)
summary(regressor)
#predicting test set result
y_pred= predict(regressor, newdata = test_set)
y_pred
#visualization the training result

library(ggplot2)
ggplot()+ 
  geom_point(aes(x = training_set$YearsExperience, y= training_set$Salary), colour= 'red')+
  geom_line(aes(x= training_set$YearsExperience, y=predict(regressor, newdata = training_set)),colour= 'blue')+
  ggtitle('salary vs experience(training_set)')+
  xlab('year of experience')+
  ylab('salary')
#visualization the test result
ggplot()+ 
  geom_point(aes(x = test_set$YearsExperience, y= test_set$Salary), colour= 'red')+
  geom_line(aes(x= training_set$YearsExperience, y=predict(regressor, newdata = training_set)),colour= 'blue')+
  ggtitle('salary vs experience(training_set)')+
  xlab('year of experience')+
  ylab('salary')