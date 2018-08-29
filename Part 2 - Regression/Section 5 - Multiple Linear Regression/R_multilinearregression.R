# multiple linear regression
# we dont need feature scaling for this because library will take care of that
#------------------------------
# Importing the dataset
dataset = read.csv('50_Startups.csv')
# Encoding categorical data
#state actually a categorical variable, we can't add directly it to independent variable equation so we need to create a dummy variable
dataset$State = factor(dataset$State,
                         levels = c('New York', 'California', 'Florida'),
                         labels = c(1, 2, 3))

# Splitting the dataset into the Training set and Test set
#install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(dataset$Profit, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)
# Feature Scaling
# training_set = scale(training_set)
# test_set = scale(test_set)

#fitting multiple linear regressor to training set
#Profit ~ . will provide data in summary  which have most significance level
regressor = lm(formula = Profit ~ .,
               data = training_set)
summary(regressor)
#( you can write all independent variable is .(dot))
#predicting the test set result
y_pred= predict(regressor, newdata = test_set)
y_pred
# building the optimal model using backword elimination
#(change space and & symbol to .)
regressor = lm(formula = Profit ~ R.D.Spend+Administration+Marketing.Spend,
               data = dataset)
#here we are taling whole dataset
#lesser  the p-value , more the impact of independent on dependent variable
summary(regressor)
regressor = lm(formula = Profit ~ R.D.Spend+Marketing.Spend,
               data = dataset)
#after removing administrative variable, p-value of matketing.spend come more closer in range
summary(regressor)
regressor = lm(formula = Profit ~ R.D.Spend,
               data = dataset)
summary(regressor)
