#Support Vector Machine
#---------------------------------------
#SVM works by identifying the optimal decision boundary that separates data points from different groups (or classes), and then predicts the class of new observations based on this separation boundary.
#Depending on the situations, the different groups might be separable by a linear straight line or by a non-linear boundary line.
#Support vector machine methods can handle both linear and non-linear class boundaries. It can be used for both two-class and multi-class classification problems.
#In real life data, the separation boundary is generally nonlinear. Technically, the SVM algorithm perform a non-linear classification using what is called the kernel trick. The most commonly used kernel transformations are polynomial kernel and radial kernel.
#there is also an extension of the SVM for regression, called support vector regression.
install.packages("mlbench")
library(tidyverse)  #tidyverse for easy data manipulation and visualization
library(caret)      #caret for easy machine learning workflow
library(lattice)
# Load the data
data("PimaIndiansDiabetes2", package = "mlbench")
pima.data <- na.omit(PimaIndiansDiabetes2)
# Inspect the data
sample_n(pima.data, 3)
# Split the data into training and test set
set.seed(123)
training.samples <- pima.data$diabetes %>%
  createDataPartition(p = 0.8, list = FALSE)
train.data  <- pima.data[training.samples, ]
test.data <- pima.data[-training.samples, ]
#-------------------------SVM linear classifier-----------------------
#In the following example variables are normalized to make their scale comparable. This is automatically done before building the SVM classifier by setting the option preProcess = c("center","scale").
# Fit the model on the training set
set.seed(123)
model <- train(
  diabetes ~., data = train.data, method = "svmLinear",
  trControl = trainControl("cv", number = 10),
  preProcess = c("center","scale")
)
# Make predictions on the test data
predicted.classes <- model %>% predict(test.data)
head(predicted.classes)
# Compute model accuracy rate
mean(predicted.classes == test.data$diabetes)
#By default caret builds the SVM linear classifier using C = 1. You can check this by typing model in R console.
#It's possible to automatically compute SVM for different values of `C and to choose the optimal one that maximize the model cross-validation accuracy
# Fit the model on the training set
set.seed(123)
model <- train(
  diabetes ~., data = train.data, method = "svmLinear",
  trControl = trainControl("cv", number = 10),
  tuneGrid = expand.grid(C = seq(0, 2, length = 20)),
  preProcess = c("center","scale")
)
# Plot model accuracy vs different values of Cost
plot(model)
# Print the best tuning parameter C that
# maximizes model accuracy
model$bestTune
# Make predictions on the test data
predicted.classes <- model %>% predict(test.data)
# Compute model accuracy rate
mean(predicted.classes == test.data$diabetes)
#------------------------SVM classifier using Non-Linear Kernel-----------------------
#To build a non-linear SVM classifier, we can use either polynomial kernel or radial kernel function. Again, the caret package can be used to easily computes the polynomial and the radial SVM non-linear models.
#The package automatically choose the optimal values for the model tuning parameters, where optimal is defined as values that maximize the model accuracy.
#---Computing SVM using radial basis kernel:
# Fit the model on the training set
set.seed(123)
model <- train(
  diabetes ~., data = train.data, method = "svmRadial",
  trControl = trainControl("cv", number = 10),
  preProcess = c("center","scale"),
  tuneLength = 10
)
# Print the best tuning parameter sigma and C that
# maximizes model accuracy
model$bestTune
# Make predictions on the test data
predicted.classes <- model %>% predict(test.data)
# Compute model accuracy rate
mean(predicted.classes == test.data$diabetes)
#------Computing SVM using polynomial basis kernel:
# Fit the model on the training set
set.seed(123)
model <- train(
  diabetes ~., data = train.data, method = "svmPoly",
  trControl = trainControl("cv", number = 10),
  preProcess = c("center","scale"),
  tuneLength = 4
)
# Print the best tuning parameter sigma and C that
# maximizes model accuracy
model$bestTune
# Make predictions on the test data
predicted.classes <- model %>% predict(test.data)
# Compute model accuracy rate
mean(predicted.classes == test.data$diabetes)
#RESULT::
#it can be seen that the SVM classifier using non-linear kernel gives a better result compared to the linear model.

