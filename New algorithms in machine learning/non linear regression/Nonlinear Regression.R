#Nonlinear Regression
#-------------------------------------------
#There are different solutions extending the linear regression model (Chapter @ref(linear-regression)) for capturing these nonlinear effects, including:
      #Polynomial regression. This is the simple approach to model non-linear relationships. It add polynomial terms or quadratic terms (square, cubes, etc) to a regression.

      #Spline regression. Fits a smooth curve with a series of polynomial segments. The values delimiting the spline segments are called Knots.

      #Generalized additive models (GAM). Fits spline models with automated selection of knots.

#------------------------------------
#In some cases, the true relationship between the outcome and a predictor variable might not be linear
library(tidyverse)   #tidyverse for easy data manipulation and visualization
library(caret)       #caret for easy machine learning workflow
theme_set(theme_classic())
# Load the data
data("Boston", package = "MASS")
view(Boston)
# Split the data into training and test set
set.seed(123)
training.samples <- Boston$medv %>%
  createDataPartition(p = 0.8, list = FALSE)
train.data  <- Boston[training.samples, ]
test.data <- Boston[-training.samples, ]
# visualize the scatter plot of the medv vs lstat variables as follow:
ggplot(train.data, aes(lstat, medv) ) +
  geom_point() +
  stat_smooth()
#--------------------------choose the model----------------------
#we'll compare the different models in order to choose the best one for our data.
#-------Linear regression {linear-reg}-
# medv = b0 + b1*lstat.
# Build the model
model <- lm(medv ~ lstat, data = train.data)
# Make predictions
predictions <- model %>% predict(test.data)
# Model performance
data.frame(
  RMSE = RMSE(predictions, test.data$medv),
  R2 = R2(predictions, test.data$medv)
)
ggplot(train.data, aes(lstat, medv) ) +  #visulize data
  geom_point() +
  stat_smooth(method = lm, formula = y ~ x)
#----------Polynomial regression
#medv=b0+b1???lstat+b2???lstat^2
lm(medv ~ poly(lstat, 2, raw = TRUE), data = train.data)  #can be used  lm(medv ~ lstat + I(lstat^2), data = train.data)
#The output contains two coefficients associated with lstat : one for the linear term (lstat^1) and one for the quadratic term (lstat^2).
lm(medv ~ poly(lstat, 6, raw = TRUE), data = train.data) %>%   #computes a sixfth-order polynomial fit:
summary()
#it can be seen that polynomial terms beyond the fith order are not significant. So, just create a fith polynomial regression model as follow:
# Build the model
model <- lm(medv ~ poly(lstat, 5, raw = TRUE), data = train.data)   # so again start after knowing order
# Make predictions
predictions <- model %>% predict(test.data)
# Model performance
data.frame(
  RMSE = RMSE(predictions, test.data$medv),
  R2 = R2(predictions, test.data$medv)
)
ggplot(train.data, aes(lstat, medv) ) +   # visulization new model
  geom_point() +
  stat_smooth(method = lm, formula = y ~ poly(x, 5, raw = TRUE))
#----------------Log transformation
#When you have a non-linear relationship, you can also try a logarithm transformation of the predictor variables:
# Build the model
model <- lm(medv ~ log(lstat), data = train.data)
# Make predictions
predictions <- model %>% predict(test.data)
# Model performance
data.frame(
  RMSE = RMSE(predictions, test.data$medv),
  R2 = R2(predictions, test.data$medv)
)
ggplot(train.data, aes(lstat, medv) ) +   #visulization
  geom_point() +
  stat_smooth(method = lm, formula = y ~ log(x))
#---------------Spline regression
install.packages("magrittr")
library(magrittr)    # for  function %>%
#Polynomial regression only captures a certain amount of curvature in a nonlinear relationship. An alternative, and often superior, approach to modeling nonlinear relationships is to use splines (P. Bruce and Bruce 2017)
#Splines provide a way to smoothly interpolate between fixed points, called knots. Polynomial regression is computed between knots.
#In other words, splines are series of polynomial segments strung together, joining at knots (P. Bruce and Bruce 2017).
#The R package splines includes the function bs for creating a b-spline term in a regression model.
#You need to specify two parameters: the degree of the polynomial and the location of the knots. In our example, we'll place the knots at the lower quartile, the median quartile, and the upper quartile:
summary(train.data)
knots <- quantile(train.data$lstat, p = c(0.25, 0.5, 0.75))
#We'll create a model using a cubic spline (degree = 3):
install.packages("splines")
library(splines)
# Build the model
knots <- quantile(train.data$lstat, p = c(0.25, 0.5, 0.75))
model <- lm (medv ~ bs(lstat, knots = knots), data = train.data)
# Make predictions
predictions <- model %>% predict(test.data)

# Model performance
install.packages("caret")
library(caret)
data.frame(
  RMSE = RMSE(predictions, test.data$medv),
  R2 = R2(predictions, test.data$medv)
)
#Note that, the coefficients for a spline term are not interpretable.
ggplot(train.data, aes(lstat, medv) ) +
  geom_point() +
  stat_smooth(method = lm, formula = y ~ splines::bs(x, df = 3))   #visulize
#---------------Generalized additive models
#Once you have detected a non-linear relationship in your data, the polynomial terms may not be flexible enough to capture the relationship, and spline terms require specifying the knots.
#Generalized additive models, or GAM, are a technique to automatically fit a spline regression. This can be done using the mgcv R package:
library(mgcv)
# Build the model
model <- gam(medv ~ s(lstat), data = train.data)   #The term s(lstat) tells the gam() function to find the "best" knots for a spline term.
# Make predictions
predictions <- model %>% predict(test.data)
# Model performance
data.frame(
  RMSE = RMSE(predictions, test.data$medv),
  R2 = R2(predictions, test.data$medv)
)
ggplot(train.data, aes(lstat, medv) ) +
  geom_point() +
  stat_smooth(method = gam, formula = y ~ s(x))   #visulize
#==========inference===============
#From analyzing the RMSE and the R2 metrics of the different models,
#it can be seen that the polynomial regression, the spline regression and the generalized additive models outperform the linear regression model and the log transformation approaches.
