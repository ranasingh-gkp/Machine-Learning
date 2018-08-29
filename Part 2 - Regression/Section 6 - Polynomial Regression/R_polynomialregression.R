# polynomial regression

# Importing the dataset
dataset = read.csv('Position_Salaries.csv')
dataset= dataset[2:3]
# Splitting the dataset into the Training set and Test set
# install.packages('caTools')
#library(caTools)
#set.seed(123)
#split = sample.split(dataset$DependentVariable, SplitRatio = 0.8)
#training_set = subset(dataset, split == TRUE)
#test_set = subset(dataset, split == FALSE)

# Feature Scaling
# training_set = scale(training_set)
# test_set = scale(test_set)

# fittin linear regression to dataset
lin_reg= lm(formula = Salary ~ .,
            data= dataset)
summary(lin_reg)

## fittin polynomial regression to dataset
dataset$Level2 = dataset$Level^2
dataset$Level3 = dataset$Level^3
dataset$Level4 = dataset$Level^4
poly_reg= lm(formula = Salary ~ .,
            data= dataset)
summary(poly_reg)

#visulization the linear regression results
install.packages('ggplot2')
library(ggplot2)
ggplot()+
  geom_point(aes(x= dataset$Level, y= dataset$Salary),color='red')+
  geom_line(aes(x= dataset$Level, y= predict(lin_reg, newdata = dataset)),color='blue')+
  ggtitle('truth (lin reg)')+
  xlab('level')+
  ylab('salary')


#visulization the polynomial regression results
ggplot()+
  geom_point(aes(x= dataset$Level, y= dataset$Salary),color='red')+
  geom_line(aes(x= dataset$Level, y= predict(poly_reg, newdata = dataset)),color='blue')+
  ggtitle('truth (poly reg)')+
  xlab('level')+
  ylab('salary')

#predict new result with linearl regression 
y_pred = predict(lin_reg, data.frame(Level=6.5))
#  since dataset is not having level 6.5 so we will create a new level by using data.frame(level==6.5)
y_pred
#prediction new result by polynomial regression
y_pred = predict(poly_reg, data.frame(Level=6.5,
                                      Level2=6.5^2,
                                      Level3=6.5^3,
                                      Level4=6.5^4))
y_pred
