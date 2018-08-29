#Gradient Boosting
#http://www.sthda.com/english/articles/35-statistical-machine-learning-essentials/139-gradient-boosting-essentials-in-r-using-xgboost/
#------------------------------
?xgboost # to know  more
#This chapter describes an alternative method called boosting, which is similar to the bagging method, except that the trees are grown sequentially: each successive tree is grown using information from previously grown trees, with the aim to minimize the error of the previous models (James et al. 2014).
#given a current regression tree model, the procedure is as follow:
    #Fit a decision tree using the model residual errors as the outcome variable.
    #Add this new decision tree, adjusted by a shrinkage parameter lambda, into the fitted function in order to update the residuals. lambda is a small positive value, typically comprised between 0.01 and 0.001 (James et al. 2014).
#This approach results in slowly and successively improving the fitted the model resulting a very performant model. Boosting has different tuning parameters including:
    #The number of trees B
    #The shrinkage parameter lambda
    #The number of splits in each tree.
#There are different variants of boosting, including Adaboost, gradient boosting and stochastic gradient boosting.
#Stochastic gradient boosting, implemented in the R package xgboost, is the most commonly used boosting technique, which involves resampling of observations and columns in each round. It offers the best performance. xgboost stands for extremely gradient boosting.
#Boosting can be used for both classification and regression problems.
install.packages("xgboost")
library(tidyverse)  #tidyverse for easy data manipulation and visualization
library(caret)      #caret for easy machine learning workflow
library(xgboost)    #xgboost for computing boosting algorithm
#=======================classification regression==================
# Load the data and remove NAs
data("PimaIndiansDiabetes2", package = "mlbench")
PimaIndiansDiabetes2 <- na.omit(PimaIndiansDiabetes2)
# Inspect the data
sample_n(PimaIndiansDiabetes2, 3)
# Split the data into training and test set
set.seed(123)
training.samples <- PimaIndiansDiabetes2$diabetes %>% 
  createDataPartition(p = 0.8, list = FALSE)
train.data  <- PimaIndiansDiabetes2[training.samples, ]
test.data <- PimaIndiansDiabetes2[-training.samples, ]
#We'll use the caret workflow, which invokes the xgboost package, to automatically adjust the model parameter values, and fit the final best boosted tree that explains the best our data.
#We'll use the following arguments in the function train():
# Fit the model on the training set
set.seed(123)
model <- train(
  diabetes ~., data = train.data, method = "xgbTree",
  trControl = trainControl("cv", number = 10)
)
# Best tuning parameter
model$bestTune
# Make predictions on the test data
predicted.classes <- model %>% predict(test.data)
head(predicted.classes)
# Compute model prediction accuracy rate
mean(predicted.classes == test.data$diabetes)
#The prediction accuracy on new test data is 78%, which is good.
#--------------Variable importance
#The function varImp() [in caret] displays the importance of variables in percentage:
varImp(model)
#=======================Regression=====================
#you can build a random forest model to perform regression, that is to predict a continuous variable.
# Load the data
data("Boston", package = "MASS")
# Inspect the data
sample_n(Boston, 3)
# Split the data into training and test set
set.seed(123)
training.samples <- Boston$medv %>%
  createDataPartition(p = 0.8, list = FALSE)
train.data  <- Boston[training.samples, ]
test.data <- Boston[-training.samples, ]
#-----Boosted regression trees
#Here the prediction error is measured by the RMSE,
#RMSE is computed as RMSE = mean((observeds - predicteds)^2) %>% sqrt(). 
#The lower the RMSE, the better the model.
# Fit the model on the training set
set.seed(123)
model <- train(
  medv ~., data = train.data, method = "xgbTree",
  trControl = trainControl("cv", number = 10)
)
# Best tuning parameter mtry
model$bestTune
# Make predictions on the test data
predictions <- model %>% predict(test.data)
head(predictions)
# Compute the average prediction error RMSE
RMSE(predictions, test.data$medv)
