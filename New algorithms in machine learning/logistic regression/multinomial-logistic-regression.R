#multinomial-logistic-regression
#--------------------------------------
# It is used when the outcome involves more than two classes.
library(tidyverse)  #tidyverse for easy data manipulation
library(caret)   #caret for easy predictive modeling
library(nnet)    #nnet for computing multinomial logistic regression
# Load the data
data("iris")
# Inspect the data
sample_n(iris, 3)
# Split the data into training and test set
set.seed(123)
training.samples <- iris$Species %>% 
  createDataPartition(p = 0.8, list = FALSE)
train.data  <- iris[training.samples, ]
test.data <- iris[-training.samples, ]
#--------------Computing multinomial logistic regression-------------
# Fit the model
model <- multinom(Species ~., data = train.data)
# Summarize the model
summary(model)
# Make predictions
predicted.classes <- model %>% predict(test.data)
head(predicted.classes)
# Model accuracy
mean(predicted.classes == test.data$Species)
#Our model is very good in predicting the different categories with an accuracy of 97%.
#===========================================================================
#Discriminant Analysis--better
#----------------------------------
#Discriminant analysis is used to predict the probability of belonging to a given class (or category) based on one or multiple predictor variables. It works with continuous and/or categorical predictor variables.
#more suitable for predicting the category of an observation in the situation where the outcome variable contains more than two classes.
library(tidyverse)  #tidyverse for easy data manipulation and visualization
library(caret)      #caret for easy machine learning workflow
theme_set(theme_bw())
# Load the data
data("iris")
# Inspect the data
sample_n(iris, 3)
# Split the data into training and test set
set.seed(123)
training.samples <- iris$Species %>% 
  createDataPartition(p = 0.8, list = FALSE)
train.data  <- iris[training.samples, ]
test.data <- iris[-training.samples, ]
#Discriminant analysis can be affected by the scale/unit in which predictor variables are measured. It's generally recommended to standardize/normalize continuous predictor before the analysis.
#Normalize the data. Categorical variables are automatically ignored.
# Estimate preprocessing parameters
preproc.param <- train.data %>% 
  preProcess(method = c("center", "scale"))
# Transform the data using the estimated parameters
train.transformed <- preproc.param %>% predict(train.data)
test.transformed <- preproc.param %>% predict(test.data)
#-----------1)Linear discriminant analysis - LDA-----------------------
#LDA assumes that predictors are normally distributed (Gaussian distribution) and that the different classes have class-specific means and equal variance/covariance.
#Before performing LDA, consider:
          #Inspecting the univariate distributions of each variable and make sure that they are normally distribute. If not, you can transform them using log and root for exponential distributions and Box-Cox for skewed distributions.
          #removing outliers from your data and standardize the variables to make their scale comparable.
#The linear discriminant analysis can be easily computed using the function lda() [MASS package].
library(MASS)
# Fit the model
model <- lda(Species~., data = train.transformed)
# Make predictions
predictions <- model %>% predict(test.transformed)
# Model accuracy
mean(predictions$class==test.transformed$Species)
library(MASS)
model <- lda(Species~., data = train.transformed)    #Compute LDA
model
#Prior probabilities of groups: the proportion of training observations in each group. For example, there are 31% of the training observations in the setosa group
#Group means: group center of gravity. Shows the mean of each variable in each group.
#Coefficients of linear discriminants: Shows the linear combination of predictor variables that are used to form the LDA decision rule.
#LD1 = 0.91*Sepal.Length + 0.64*Sepal.Width - 4.08*Petal.Length - 2.3*Petal.Width.
#LD2 = 0.03*Sepal.Length + 0.89*Sepal.Width - 2.2*Petal.Length - 2.6*Petal.Width.
plot(model)
predictions <- model %>% predict(test.transformed)   #Make predictions:
predictions
names(predictions)
# Predicted classes
head(predictions$class, 6)
# Predicted probabilities of class memebership.
head(predictions$posterior, 6) 
# Linear discriminants
head(predictions$x, 3) 
lda.data <- cbind(train.transformed, predict(model)$x)    #plot
ggplot(lda.data, aes(LD1, LD2)) +
  geom_point(aes(color = Species))
mean(predictions$class==test.transformed$Species)    #model accuracy
#It can be seen that, our model correctly classified 100% of observations, which is excellent.
#------------2)Quadratic discriminant analysis - QDA-----------------
#QDA is little bit more flexible than LDA, in the sense that it does not assumes the equality of variance/covariance. In other words, for QDA the covariance matrix can be different for each class.
#LDA tends to be a better than QDA when you have a small training set.
#QDA is recommended if the training set is very large, so that the variance of the classifier is not a major issue, or if the assumption of a common covariance matrix for the K classes is clearly untenable (James et al. 2014).
#QDA can be computed using the R function qda() [MASS package]
library(MASS)
# Fit the model
model <- qda(Species~., data = train.transformed)
model
# Make predictions
predictions <- model %>% predict(test.transformed)
predictions
# Model accuracy
mean(predictions$class == test.transformed$Species)
#------------------3)Mixture discriminant analysis - MDA-----------------------
#there are classes, and each class is assumed to be a Gaussian mixture of subclasses, where each data point has a probability of belonging to each class.
#Equality of covariance matrix, among classes, is still assumed.
install.packages("mda")
library(mda)
# Fit the model
model <- mda(Species~., data = train.transformed)
model
# Make predictions
predicted.classes <- model %>% predict(test.transformed)
# Model accuracy
mean(predicted.classes == test.transformed$Species)
#----------------------4)Flexible discriminant analysis - FDA-----------------------
#FDA is a flexible extension of LDA that uses non-linear combinations of predictors such as splines.
#FDA is useful to model multivariate non-normality or non-linear relationships among variables within each group, allowing for a more accurate classification.
library(mda)
# Fit the model
model <- fda(Species~., data = train.transformed)
# Make predictions
predicted.classes <- model %>% predict(test.transformed)
# Model accuracy
mean(predicted.classes == test.transformed$Species)
#-----------------------5)Regularized discriminant analysis------------------------
#This might be very useful for a large multivariate data set containing highly correlated predictors.
#This improves the estimate of the covariance matrices in situations where the number of predictors is larger than the number of samples in the training data, potentially leading to an improvement of the model accuracy.
install.packages("klaR")
library(klaR)
# Fit the model
model <- rda(Species~., data = train.transformed)
# Make predictions
predictions <- model %>% predict(test.transformed)
# Model accuracy
mean(predictions$class == test.transformed$Species)
#----------------------------------------------------
#LDA tends to be better than QDA for small data set. QDA is recommended for large training data set.
#LDA assumes that the different classes has the same variance or covariance matrix.