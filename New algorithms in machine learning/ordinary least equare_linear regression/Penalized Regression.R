#Penalized Regression
#These methods are very useful in a situation, where you have a large multivariate data sets.
#http://www.sthda.com/english/articles/37-model-selection-essentials-in-r/153-penalized-regression-essentials-ridge-lasso-elastic-net/

#-----------------------------------
#This is also known as shrinkage or regularization methods.
#The consequence of imposing this penalty, is to reduce (i.e. shrink) the coefficient values towards zero. This allows the less contributive variables to have a coefficient close to zero or equal zero.
library(tidyverse)  #tidyverse for easy data manipulation and visualization
library(caret)      #caret for easy machine learning workflow
library(glmnet)     #glmnet, for computing penalized regression
install.packages("glmnet")
# Load the data
data("Boston", package = "MASS")
# Split the data into training and test set
set.seed(123)
training.samples <- Boston$medv %>%
  createDataPartition(p = 0.8, list = FALSE)
train.data  <- Boston[training.samples, ]
test.data <- Boston[-training.samples, ]
#-----Additional data preparation
#y for storing the outcome variable
#x for holding the predictor variables. This should be created using the function model.matrix() allowing to automatically transform any qualitative variables (if any) into dummy variables
#     (Chapter @ref(regression-with-categorical-variables)), which is important because glmnet() can only take numerical, quantitative inputs. After creating the model matrix, we remove the intercept component at index = 1.
# Predictor variables
x <- model.matrix(medv~., train.data)[,-1]
# Outcome variable
y <- train.data$medv
#----------r function
#We'll use the R function glmnet() [glmnet package] for computing penalized linear regression models.
glmnet(x, y, alpha = 1, lambda = NULL)
#x: matrix of predictor variables
#y: the response or outcome variable, which is a binary variable.
#alpha: the elasticnet mixing parameter. Allowed values include:
        #"1": for lasso regression
        #"0": for ridge regression
        #a value between 0 and 1 (say 0.3) for elastic net regression. 
#lamba: a numeric value defining the amount of shrinkage. Should be specify by analyst.
#you need to specify a constant lambda to adjust the amount of the coefficient shrinkage. The best lambda for your data, can be defined as the lambda that minimize the cross-validation prediction error rate. This can be determined automatically using the function cv.glmnet().
#The best model is defined as the model that has the lowest prediction error, RMSE (Chapter @ref(regression-model-accuracy-metrics)).

#-------------------------------Ridge regression-----------------------------
#Ridge regression shrinks the regression coefficients, so that variables, with minor contribution to the outcome, have their coefficients close to zero.
#The shrinkage of the coefficients is achieved by penalizing the regression model with a penalty term called L2-norm, which is the sum of the squared coefficients.
#The amount of the penalty can be fine-tuned using a constant called lambda (??). Selecting a good value for ?? is critical.
#When ??=0, the penalty term has no effect, and ridge regression will produce the classical least square coefficients. However, as ?? increases to infinite, the impact of the shrinkage penalty grows, and the ridge regression coefficients will get close zero.
#Note that, in contrast to the ordinary least square regression, ridge regression is highly affected by the scale of the predictors. Therefore, it is better to standardize (i.e., scale) the predictors before applying the ridge regression (James et al. 2014), so that all the predictors are on the same scale.
#The standardization of a predictor x, can be achieved using the formula x' = x / sd(x), where sd(x) is the standard deviation of x. The consequence of this is that, all standardized predictors will have a standard deviation of one allowing the final fit to not depend on the scale on which the predictors are measured.
#One important advantage of the ridge regression, is that it still performs well, compared to the ordinary least square method (Chapter @ref(linear-regression)), in a situation where you have a large multivariate data with the number of predictors (p) larger than the number of observations (n).
#One disadvantage of the ridge regression is that, it will include all the predictors in the final model, unlike the stepwise regression methods (Chapter @ref(stepwise-regression)), which will generally select models that involve a reduced set of variables.
#Ridge regression shrinks the coefficients towards zero, but it will not set any of them exactly to zero. The lasso regression is an alternative that overcomes this drawback.
# Find the best lambda using cross-validation
set.seed(123) 
cv <- cv.glmnet(x, y, alpha = 0)
# Display the best lambda value
cv$lambda.min
# Fit the final model on the training data
model <- glmnet(x, y, alpha = 0, lambda = cv$lambda.min)
# Display regression coefficients
coef(model)
# Make predictions on the test data
x.test <- model.matrix(medv ~., test.data)[,-1]
predictions <- model %>% predict(x.test) %>% as.vector()
# Model performance metrics
data.frame(
  RMSE = RMSE(predictions, test.data$medv),
  Rsquare = R2(predictions, test.data$medv)
)
#Note that by default, the function glmnet() standardizes variables so that their scales are comparable. However, the coefficients are always returned on the original scale.
#------------------------------------lasso regression------------------------------
#Lasso stands for Least Absolute Shrinkage and Selection Operator. It shrinks the regression coefficients toward zero by penalizing the regression model with a penalty term called L1-norm, which is the sum of the absolute coefficients.
#the penalty has the effect of forcing some of the coefficient estimates, with a minor contribution to the model, to be exactly equal to zero. This means that, lasso can be also seen as an alternative to the subset selection methods for performing variable selection in order to reduce the complexity of the model.
#selecting a good value of ?? for the lasso is critical.
#One obvious advantage of lasso regression over ridge regression, is that it produces simpler and more interpretable models that incorporate only a reduced set of the predictors.
#Ridge regression will perform better when the outcome is a function of many predictors, all with coefficients of roughly equal size (James et al. 2014).
#Cross-validation methods can be used for identifying which of these two techniques is better on a particular data set.

#The only difference between the R code used for ridge regression is that, for lasso regression you need to specify the argument alpha = 1 instead of alpha = 0 (for ridge regression).
# Find the best lambda using cross-validation
set.seed(123) 
cv <- cv.glmnet(x, y, alpha = 1)
# Display the best lambda value
cv$lambda.min
# Fit the final model on the training data
model <- glmnet(x, y, alpha = 1, lambda = cv$lambda.min)
# Dsiplay regression coefficients
coef(model)
# Make predictions on the test data
x.test <- model.matrix(medv ~., test.data)[,-1]
predictions <- model %>% predict(x.test) %>% as.vector()
# Model performance metrics
data.frame(
  RMSE = RMSE(predictions, test.data$medv),
  Rsquare = R2(predictions, test.data$medv)
)
#---------------------------------------elastic net regession----------------------------
#Elastic Net produces a regression model that is penalized with both the L1-norm and L2-norm. The consequence of this is to effectively shrink coefficients (like in ridge regression) and to set some coefficients to zero (as in LASSO).
#The elastic net regression can be easily computed using the caret workflow, which invokes the glmnet package.
#We use caret to automatically select the best tuning parameters alpha and lambda. The caret packages tests a range of possible alpha and lambda values, then selects the best values for lambda and alpha, resulting to a final model that is an elastic net model.
#Here, we'll test the combination of 10 different values for alpha and lambda. This is specified using the option tuneLength.
#The best alpha and lambda values are those values that minimize the cross-validation error
# Build the model using the training set
set.seed(123)
model <- train(
  medv ~., data = train.data, method = "glmnet",
  trControl = trainControl("cv", number = 10),
  tuneLength = 10
)
# Best tuning parameter
model$bestTune
# Coefficient of the final model. You need
# to specify the best lambda
coef(model$finalModel, model$bestTune$lambda)
# Make predictions on the test data
x.test <- model.matrix(medv ~., test.data)[,-1]
predictions <- model %>% predict(x.test)
# Model performance metrics
data.frame(
  RMSE = RMSE(predictions, test.data$medv),
  Rsquare = R2(predictions, test.data$medv)
)
#All things equal, we should go for the simpler model. In our example, we can choose the lasso or the elastic net regression models.
#============================================================
#-----------------------Using caret package------------------------------
#caret will automatically choose the best tuning parameter values, compute the final model and evaluate the model performance using cross-validation techniques.
#-------Setup a grid range of lambda values::
lambda <- 10^seq(-3, 3, length = 100)
lambda
#---------Compute ridge regression::
# Build the model
set.seed(123)
ridge <- train(
  medv ~., data = train.data, method = "glmnet",
  trControl = trainControl("cv", number = 10),
  tuneGrid = expand.grid(alpha = 0, lambda = lambda)
)
# Model coefficients
coef(ridge$finalModel, ridge$bestTune$lambda)
# Make predictions
predictions <- ridge %>% predict(test.data)
# Model prediction performance
data.frame(
  RMSE = RMSE(predictions, test.data$medv),
  Rsquare = R2(predictions, test.data$medv)
)
#----------Compute lasso regression:
# Build the model
set.seed(123)
lasso <- train(
  medv ~., data = train.data, method = "glmnet",
  trControl = trainControl("cv", number = 10),
  tuneGrid = expand.grid(alpha = 1, lambda = lambda)
)
# Model coefficients
coef(lasso$finalModel, lasso$bestTune$lambda)
# Make predictions
predictions <- lasso %>% predict(test.data)
# Model prediction performance
data.frame(
  RMSE = RMSE(predictions, test.data$medv),
  Rsquare = R2(predictions, test.data$medv)
)
#-----------Elastic net regression:
# Build the model
set.seed(123)
elastic <- train(
  medv ~., data = train.data, method = "glmnet",
  trControl = trainControl("cv", number = 10),
  tuneLength = 10
)
# Model coefficients
coef(elastic$finalModel, elastic$bestTune$lambda)
# Make predictions
predictions <- elastic %>% predict(test.data)
# Model prediction performance
data.frame(
  RMSE = RMSE(predictions, test.data$medv),
  Rsquare = R2(predictions, test.data$medv)
)
#------------Comparing models performance:
#The performance of the different models - ridge, lasso and elastic net - can be easily compared using caret. The best model is defined as the one that minimizes the prediction error.
models <- list(ridge = ridge, lasso = lasso, elastic = elastic)
resamples(models) %>% summary( metric = "RMSE")
#It can be seen that the elastic net model has the lowest median RMSE.
