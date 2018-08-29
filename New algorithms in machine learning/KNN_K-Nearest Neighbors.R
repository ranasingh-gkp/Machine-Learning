#KNN: K-Nearest Neighbors
#http://www.sthda.com/english/articles/35-statistical-machine-learning-essentials/142-knn-k-nearest-neighbors-essentials/
#----------------------------------------
#The kNN algorithm predicts the outcome of a new observation by comparing it to k similar cases in the training data set, where k is defined by the analyst.
library(tidyverse)  #tidyverse for easy data manipulation and visualization
library(caret)      #caret for easy machine learning workflow
#----------KNN algorithm for classification:
#To classify a given new observation (new_obs), the k-nearest neighbors method starts by identifying the k most similar training observations (i.e. neighbors) to our new_obs, and then assigns new_obs to the class containing the majority of its neighbors.
#---------KNN algorithm for regression:
#Similarly, to predict a continuous outcome value for given new observation (new_obs), the KNN algorithm computes the average outcome value of the k training observations that are the most similar to new_obs, and returns this value as new_obs predicted outcome value.
#---------Similarity measures:
#Note that, the (dis)similarity between observations is generally determined using Euclidean distance measure, which is very sensitive to the scale on which predictor variable measurements are made. 
#So, it's generally recommended to standardize (i.e., normalize) the predictor variables for making their scales comparable.

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
#=======================classification regression=============================
#We'll use the caret package, which automatically tests different possible values of k, then chooses the optimal k that minimizes the cross-validation ("cv") error, and fits the final best KNN model that explains the best our data.
#Additionally caret can automatically preprocess the data in order to normalize the predictor variables.
#We'll use the following arguments in the function train():
    #trControl, to set up 10-fold cross validation
    #preProcess, to normalize the data
    #tuneLength, to specify the number of possible k values to evaluate
# Fit the model on the training set
set.seed(123)
model <- train(
  diabetes ~., data = train.data, method = "knn",
  trControl = trainControl("cv", number = 10),
  preProcess = c("center","scale"),
  tuneLength = 20
)
# Plot model accuracy vs different values of k
plot(model)
# Print the best tuning parameter k that maximizes model accuracy
model$bestTune
# Make predictions on the test data
predicted.classes <- model %>% predict(test.data)
head(predicted.classes)
# Compute model accuracy rate
mean(predicted.classes == test.data$diabetes)
#=========================for regression===========================
#In this section, we'll describe how to predict a continuous variable using KNN.
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
#---------Compute KNN using caret.
#The best k is the one that minimize the prediction error RMSE (root mean squared error).
#RMSE = mean((observeds - predicteds)^2) %>% sqrt(). The lower the RMSE, the better the model.
# Fit the model on the training set
set.seed(123)
model <- train(
  medv~., data = train.data, method = "knn",
  trControl = trainControl("cv", number = 10),
  preProcess = c("center","scale"),
  tuneLength = 10
)
# Plot model error RMSE vs different values of k
plot(model)
# Best tuning parameter k that minimize the RMSE
model$bestTune
# Make predictions on the test data
predictions <- model %>% predict(test.data)
head(predictions)
# Compute the prediction error RMSE
RMSE(predictions, test.data$medv)
