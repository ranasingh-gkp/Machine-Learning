#Stepwise Regression
#http://www.sthda.com/english/articles/37-model-selection-essentials-in-r/154-stepwise-regression-essentials-in-r/

#------------------------------------
#The stepwise regression (or stepwise selection) consists of iteratively adding and removing predictors, in the predictive model, in order to find the subset of variables in the data set resulting in the best performing model, that is a model that lowers prediction error.
#There are three strategies of stepwise regression (James et al. 2014,P. Bruce and Bruce (2017)):
        #Forward selection, which starts with no predictors in the model, iteratively adds the most contributive predictors, and stops when the improvement is no longer statistically significant.
        #Backward selection (or backward elimination), which starts with all predictors in the model (full model), iteratively removes the least contributive predictors, and stops when you have a model where all predictors are statistically significant.
        #Stepwise selection (or sequential replacement), which is a combination of forward and backward selections. You start with no predictors, then sequentially add the most contributive predictors (like forward selection). After adding each new variable, remove any variables that no longer provide an improvement in the model fit (like backward selection).
#NOTES::
    #forward selection and stepwise selection can be applied in the high-dimensional configuration, where the number of samples n is inferior to the number of predictors p, such as in genomic fields
    #Backward selection requires that the number of samples n is larger than the number of variables p, so that the full model can be fit.
library(tidyverse)  #tidyverse for easy data manipulation and visualization
library(caret)      #caret for easy machine learning workflow
library(leaps)      #leaps, for computing stepwise regression
#stepAIC() [MASS package], which choose the best model by AIC. It has an option named direction, which can take the following values: i) "both" (for stepwise regression, both forward and backward selection); "backward" (for backward selection) and "forward" (for forward selection). It return the best final model.
library(MASS)
data(swiss)
swiss
# Fit the full model 
full.model <- lm(Fertility ~., data = swiss)
# Stepwise regression model
step.model <- stepAIC(full.model, direction = "both", 
                      trace = FALSE)
summary(step.model)
#regsubsets() [leaps package], which has the tuning parameter nvmax specifying the maximal number of predictors to incorporate in the model
# regsubsets() has the option method, which can take the values "backward", "forward" and "seqrep" (seqrep = sequential replacement, combination of forward and backward selections).
models <- regsubsets(Fertility~., data = swiss, nvmax = 5,
                     method = "seqrep")
summary(models)
#train() function [caret package] provides an easy workflow to perform stepwise selections using the leaps and the MASS packages. It has an option named method, which can take the following values:
#"leapBackward", to fit linear regression with backward selection
#"leapForward", to fit linear regression with forward selection
#"leapSeq", to fit linear regression with stepwise selection .
#For example, you can vary nvmax from 1 to 5. That is, it searches the best 1-variable model, the best 2-variables model, ., the best 5-variables models.
# Set seed for reproducibility
set.seed(123)
# Set up repeated k-fold cross-validation
train.control <- trainControl(method = "cv", number = 10) # use 10-fold cross-validation to estimate the average prediction error (RMSE) of each of the 5 models(see Chapter @ref(cross-validation))
# Train the model
step.model <- train(Fertility ~., data = swiss,
                    method = "leapBackward", 
                    tuneGrid = data.frame(nvmax = 1:5),
                    trControl = train.control
)
step.model$results
#RESULT::
    #nvmax: the number of variable in the model. For example nvmax = 2, specify the best 2-variables model
    #RMSE and MAE are two different metrics measuring the prediction error of each model. The lower the RMSE and MAE, the better the model.
    #Rsquared indicates the correlation between the observed outcome values and the values predicted by the model. The higher the R squared, the better the model.
step.model$bestTune
#This indicates that the best model is the one with nvmax = 4 variables
summary(step.model$finalModel)
#The function summary() reports the best set of variables for each model size, up to the best 4-variables model.
#An asterisk specifies that a given variable is included in the corresponding model.it can be seen that the best 4-variables model contains Agriculture, Education, Catholic, Infant.Mortality (Fertility ~ Agriculture + Education + Catholic + Infant.Mortality).
coef(step.model$finalModel, 4)  #The regression coefficients of the final model (id = 4) can be accessed.
# or by lm(Fertility ~ Agriculture + Education + Catholic + Infant.Mortality, data = swiss)
#-----------------------------------
#Additionally, the caret package has method to compute stepwise regression using the MASS package (method = "lmStepAIC"):
# Train the model
step.model <- train(Fertility ~., data = swiss,
                    method = "lmStepAIC", 
                    trControl = train.control,
                    trace = FALSE
)
# Model accuracy
step.model$results
# Final model coefficients
step.model$finalModel
# Summary of the model
summary(step.model$finalModel)

