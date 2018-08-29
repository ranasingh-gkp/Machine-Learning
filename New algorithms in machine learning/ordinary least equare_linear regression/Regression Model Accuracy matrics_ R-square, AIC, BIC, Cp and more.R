#Regression Model Accuracy matrics_ R-square, AIC, BIC, Cp and more
#--------------------------------------------------------------
#------Model performance metrics
#___
#///R-squared (R2) .The Higher the R-squared, the better the model.
#///Root Mean Squared Error (RMSE)  the RMSE is the square root of the mean squared error (MSE)
#MSE = mean((observeds - predicteds)^2) and RMSE = sqrt(MSE). The lower the RMSE, the better the model.
#///Residual Standard Error (RSE), also known as the model sigma.
#The lower the RSE, the better the model. In practice, the difference between RMSE and RSE is very small, particularly for large multivariate data.
#///Mean Absolute Error (MAE), like the RMSE, the MAE measures the prediction error.
#MAE = mean(abs(observeds - predicteds)). MAE is less sensitive to outliers compared to RMSE.
#___
#including additional variables in the model will always increase the R2 and reduce the RMSE. So, we need a more robust metric to guide the model choice.
#Additionally, there are four other important metrics - AIC, AICc, BIC and Mallows Cp - that are commonly used for model evaluation and selection.
#These are an unbiased estimate of the model prediction error MSE. The lower these metrics, he better the model.
#___
#AIC::The basic idea of AIC is to penalize the inclusion of additional variables to a model. It adds a penalty that increases the error when including additional terms. 
#The lower the AIC, the better the model.
#AICc is a version of AIC corrected for small sample sizes.
#BIC (or Bayesian information criteria) is a variant of AIC with a stronger penalty for including additional variables to the model.
#Mallows Cp: A variant of AIC developed by Colin Mallows
#NOTE::Generally, the most commonly used metrics, for measuring regression model quality and for comparing models, are: Adjusted R2, AIC, BIC and Cp.
library(tidyverse)  #tidyverse for data manipulation and visualization
library(modelr)     #modelr provides helper functions for computing regression model performance metrics
library(broom)     #broom creates easily a tidy data frame containing the model statistical metrics
# Load the data
data("swiss")
# Inspect the data
sample_n(swiss, 3)
model1 <- lm(Fertility ~., data = swiss)
model2 <- lm(Fertility ~. -Examination, data = swiss)
summary(model1)  #summary() [stats package], returns the R-squared, adjusted R-squared and the RSE
AIC(model1)      #AIC() and BIC() [stats package], computes the AIC and the BIC, respectively
BIC(model1)
library(caret)
predictions <- model1 %>% predict(swiss)
data.frame(
  R2 = R2(predictions, swiss$Fertility),  #R2(), RMSE() and MAE() [caret package], computes, respectively, the R2, RMSE and the MAE.
  RMSE = RMSE(predictions, swiss$Fertility),
  MAE = MAE(predictions, swiss$Fertility)
)
library(broom)
glance(model1)  #glance() [broom package], computes the R2, adjusted R2, sigma (RSE), AIC, BIC.
#___
# Make predictions and compute the R2, RMSE and MAE
swiss %>%
  add_predictions(model1) %>%    #Manual computation of R2, RMSE and MAE:
  summarise(
    R2 = cor(Fertility, pred)^2,
    MSE = mean((Fertility - pred)^2),
    RMSE = sqrt(MSE),
    MAE = mean(abs(Fertility - pred))
  )
#___
#----------Comparing regression models performance
# Metrics for model 1
glance(model1) %>%
  dplyr::select(adj.r.squared, sigma, AIC, BIC, p.value)
# Metrics for model 2
glance(model2) %>%
  dplyr::select(adj.r.squared, sigma, AIC, BIC, p.value)
#RESULT::
#SINCE all parameter are same,  the model 2 is more simple than model 1 because it incorporates less variables. All things equal, the simple model is always better in statistics.
#The AIC and the BIC of the model 2 are lower than those of the model1. In model comparison strategies, the model with the lowest AIC and BIC score is preferred.
#Finally, the F-statistic p.value of the model 2 is lower than the one of the model 1. This means that the model 2 is statistically more significant compared to model 1, which is consistent to the above conclusion.
#Dividing the RSE by the average value of the outcome variable will give you the prediction error rate, which should be as small as possible:
sigma(model1)/mean(swiss$Fertility)
# the average prediction error rate is 10%.
