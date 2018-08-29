#Naive Bayes Classifier
#Naive Bayes classifier predicts the class membership probability of observations using Bayes theorem, which is based on conditional probability, that is the probability of something to happen, given that something else has already occurred.
#Observations are assigned to the class with the largest probability score.
install.packages("mlbench")
library(tidyverse)  #tidyverse for easy data manipulation and visualization
library(caret)      #caret for easy machine learning workflow
#The input predictor variables can be categorical and/or numeric variables.
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
#-----------Computing Naive Bayes
install.packages("klaR")
library("klaR")
# Fit the model
model <- NaiveBayes(diabetes ~., data = train.data)
# Make predictions
predictions <- model %>% predict(test.data)
# Model accuracy
mean(predictions$class == test.data$diabetes)
#----------Using caret R package
#The caret R package can automatically train the model and assess the model accuracy using k-fold cross-validation 
library(klaR)
# Build the model
set.seed(123)
model <- train(diabetes ~., data = train.data, method = "nb", 
               trControl = trainControl("cv", number = 10))
# Make predictions
predicted.classes <- model %>% predict(test.data)
# Model n accuracy
mean(predicted.classes == test.data$diabetes)
