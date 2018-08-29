#Cross-Validation
#http://www.sthda.com/english/articles/38-regression-model-validation/157-cross-validation-essentials-in-r/
#R2, RMSE and MAE are used to measure the regression model performance during cross-validation.
#--------------------------------------
#The basic idea, behind cross-validation techniques, consists of dividing the data into two sets:
    #The training set, used to train (i.e. build) the model;
    #and the testing set (or validation set), used to test (i.e. validate) the model by estimating the prediction error.
library(tidyverse)  #tidyverse for easy data manipulation and visualization
library(caret)      #caret for easy machine learning workflow
# Load the data
data("swiss")
# Inspect the data
sample_n(swiss, 3)
#------------------------
#cross-validation algorithms can be summarized as follow:
#Reserve a small sample of the data set
#Build (or train) the model using the remaining part of the data set
#Test the effectiveness of the model on the the reserved sample of the data set. If the model works well on the test data set, then it's good.
#--------------------------
# Split the data into training and test set
set.seed(123)
training.samples <- swiss$Fertility %>%
  createDataPartition(p = 0.8, list = FALSE)
train.data  <- swiss[training.samples, ]
test.data <- swiss[-training.samples, ]
# Build the model
model <- lm(Fertility ~., data = train.data)
# Make predictions and compute the R2, RMSE and MAE
predictions <- model %>% predict(test.data)
data.frame( R2 = R2(predictions, test.data$Fertility),
            RMSE = RMSE(predictions, test.data$Fertility),
            MAE = MAE(predictions, test.data$Fertility))
#When comparing two models, the one that produces the lowest test sample RMSE is the preferred model.
#Note that, the validation set method is only useful when you have a large data set that can be partitioned.
RMSE(predictions, test.data$Fertility)/mean(test.data$Fertility)
#Dividing the RMSE by the average value of the outcome variable will give you the prediction error rate, which should be as small as possible:
#///NOTE::When comparing two models, the one that produces the lowest test sample RMSE is the preferred model.

#-------------------------Leave one out cross validation - LOOCV----------------------
#Leave out one data point and build the model on the rest of the data set
#Test the model against the data point that is left out at step 1 and record the test error associated with the prediction
#Repeat the process for all data points
#Compute the overall prediction error by taking the average of all these test error estimates recorded at step 2.
# Define training control
train.control <- trainControl(method = "LOOCV")
# Train the model
model <- train(Fertility ~., data = swiss, method = "lm",
               trControl = train.control)
# Summarize the results
print(model)
#----------------------------K-fold cross-validation----------------------------------
#Randomly split the data set into k-subsets (or k-fold) (for example 5 subsets)
#Reserve one subset and train the model on all other subsets
#Test the model on the reserved subset and record the prediction error
#Repeat this process until each of the k subsets has served as the test set.
#Compute the average of the k recorded errors. This is called the cross-validation error serving as the performance metric for the model
#In practice, one typically performs k-fold cross-validation using k = 5 or k = 10, as these values have been shown empirically to yield test error rate estimates that suffer neither from excessively high bias nor from very high variance.

# Define training control
set.seed(123) 
train.control <- trainControl(method = "cv", number = 10)
# Train the model
model <- train(Fertility ~., data = swiss, method = "lm",
               trControl = train.control)
# Summarize the results
print(model)
#------------------------------Repeated K-fold cross-validation--------------------------
#The process of splitting the data into k-folds can be repeated a number of times, this is called repeated k-fold cross validation.
# Define training control
set.seed(123)
train.control <- trainControl(method = "repeatedcv", 
                              number = 10, repeats = 3)
# Train the model
model <- train(Fertility ~., data = swiss, method = "lm",
               trControl = train.control)
# Summarize the results
print(model)
