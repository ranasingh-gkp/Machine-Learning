#Random Forest
#http://www.sthda.com/english/articles/35-statistical-machine-learning-essentials/140-bagging-and-random-forest-essentials/
#The standard decision tree model, CART for classification and regression trees, build only one single tree, which is then used to predict the outcome of new observations. The output of this strategy is very unstable and the tree structure might be severally affected by a small change in the training data set.
#There are different powerful alternatives to the classical CART algorithm, including bagging, Random Forest and boosting.
library(tidyverse)  #tidyverse for easy data manipulation and visualization
library(caret)      #caret for easy machine learning workflow
library(randomForest)  #randomForest for computing random forest algorithm
#===========================for classification regression==================
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
#-----Computing random forest classifier
#We'll use the caret workflow, which invokes the randomforest() function [randomForest package], to automatically select the optimal number (mtry) of predictor variables randomly sampled as candidates at each split, and fit the final best random forest model that explains the best our data.
# Fit the model on the training set
set.seed(123)
model <- train(
  diabetes ~., data = train.data, method = "rf",
  trControl = trainControl("cv", number = 10),
  importance = TRUE
)
# Best tuning parameter
model$bestTune
# Final model
model$finalModel
# Make predictions on the test data
predicted.classes <- model %>% predict(test.data)
plot(model$finalModel)
head(predicted.classes)
# Compute model accuracy rate
mean(predicted.classes == test.data$diabetes)
#By default, 500 trees are trained. The optimal number of variables sampled at each split is 5.
#Each bagged tree makes use of around two-thirds of the observations. The remaining one-third of the observations not used to fit a given bagged tree are referred to as the out-of-bag (OOB) observations (James et al. 2014).
#For a given tree, the out-of-bag (OOB) error is the model error in predicting the data left out of the training set for that tree (P. Bruce and Bruce 2017). OOB is a very straightforward way to estimate the test error of a bagged model, without the need to perform cross-validation or the validation set approach.
#In our example, the OBB estimate of error rate is 23%.
#result::The prediction accuracy on new test data is 79%, which is good.
#-------Variable importance
install.packages("randomForest ")
library(randomForest)
importance(model$finalModel)
#MeanDecreaseAccuracy, which is the average decrease of model accuracy in predicting the outcome of the out-of-bag samples when a specific variable is excluded from the model.
#MeanDecreaseGini, which is the average decrease in node impurity that results from splits over that variable. The Gini impurity index is only used for classification problem.
#Note:: that, by default (argument importance = FALSE), randomForest only calculates the Gini impurity index. However, computing the model accuracy by variable (argument importance = TRUE) requires supplementary computations which might be time consuming in the situations, where thousands of models (trees) are being fitted.
# Plot MeanDecreaseAccuracy
varImpPlot(model$finalModel, type = 1)   #randomForest package
# Plot MeanDecreaseGini
varImpPlot(model$finalModel, type = 2)
#The results show that across all of the trees considered in the random forest, the glucose and age variables are the two most important variables.
#The function varImp() [in caret] displays the importance of variables in percentage:
varImp(model)    #package caret
#===========================regression================================
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
#-----Computing random forest regression trees
#Here the prediction error is measured by the RMSE,
#RMSE is computed as RMSE = mean((observeds - predicteds)^2) %>% sqrt(). 
#The lower the RMSE, the better the model.
# Fit the model on the training set
set.seed(123)
model <- train(
  medv ~., data = train.data, method = "rf",
  trControl = trainControl("cv", number = 10)
)
# Best tuning parameter mtry
model$bestTune
# Make predictions on the test data
predictions <- model %>% predict(test.data)
plot(predictions)
head(predictions)
# Compute the average prediction error RMSE
RMSE(predictions, test.data$medv)
#========================Hyperparameters for both=====================
# the random forest algorithm has a set of hyperparameters that should be tuned using cross-validation to avoid overfitting.
# includes::
    #nodesize: Minimum size of terminal nodes. Default value for classification is 1 and default for regression is 5.
    #maxnodes: Maximum number of terminal nodes trees in the forest can have. If not given, trees are grown to the maximum possible (subject to limits by nodesize).
#Ignoring these parameters might lead to overfitting on noisy data set (P. Bruce and Bruce 2017). Cross-validation can be used to test different values, in order to select the optimal value.
#Hyperparameters can be tuned manually using the caret package. For a given parameter, the approach consists of fitting many models with different values of the parameters and then comparing the models.
#The following example tests different values of nodesize using the PimaIndiansDiabetes2 data set for classification:
data("PimaIndiansDiabetes2", package = "mlbench")
models <- list()
for (nodesize in c(1, 2, 4, 8)) {
  set.seed(123)
  model <- train(
    diabetes~., data = na.omit(PimaIndiansDiabetes2), method="rf", 
    trControl = trainControl(method="cv", number=10),
    metric = "Accuracy",
    nodesize = nodesize
  )
  model.name <- toString(nodesize)
  models[[model.name]] <- model
}
# Compare results
resamples(models) %>% summary(metric = "Accuracy")
#result::It can be seen that, using a nodesize value of 2 or 4 leads to the most median accuracy value.
