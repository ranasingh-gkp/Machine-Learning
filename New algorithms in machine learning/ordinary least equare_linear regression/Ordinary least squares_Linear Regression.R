#Ordinary least squares_Linear Regression
#http://www.sthda.com/english/articles/40-regression-analysis/165-linear-regression-essentials-in-r/
#-------------------------------------------------
#Two important metrics are commonly used to assess the performance of the predictive regression model:
#Root Mean Squared Error,::R-square, representing the squared correlation between the observed known outcome values and the predicted values by the model. The higher the R2, the better the model. which measures the model prediction error. It corresponds to the average difference between the observed known values of the outcome and the predicted value by the model. RMSE is computed as RMSE = mean((observeds - predicteds)^2) %>% sqrt(). The lower the RMSE, the better the model.
#R-square,:: representing the squared correlation between the observed known outcome values and the predicted values by the model. The higher the R2, the better the model.
#----------
#A simple workflow to build to build a predictive regression model is as follow:
#Randomly split your data into training set (80%) and test set (20%)
#Build the regression model using the training set
#Make predictions using the test set and compute the model accuracy metrics
#----------------
#The sum of the squares of the residual errors are called the Residual Sum of Squares or RSS.
#The average variation of points around the fitted regression line is called the Residual Standard Error (RSE). This is one the metrics used to evaluate the overall quality of the fitted regression model. The lower the RSE, the better it is
#y ~ b0 + b1*x
#Mathematically, the beta coefficients (b0 and b1) are determined so that the RSS is as minimal as possible.
#This method of determining the beta coefficients is technically called least squares regression or ordinary least squares (OLS) regression.
#Once, the beta coefficients are calculated, a t-test is performed to check whether or not these coefficients are significantly different from zero.
#A non-zero beta coefficients means that there is a significant relationship between the predictors (x) and the outcome variable (y).
#-----------------------
install.packages("tidyverse")
install.packages("caret")
library(tidyverse)  #tidyverse for easy data manipulation and visualization
library(caret)      #caret for easy machine learning workflow
theme_set(theme_bw())
install.packages("data.table")
install.packages('openssl')
install.packages("datarium")
install.packages("prob")
library(datarium)
# Load the data
data("marketing", package = "datarium")
# Inspect the data
sample_n(marketing, 3)
# Split the data into training and test set
set.seed(123)
training.samples <- marketing$sales %>%
  createDataPartition(p = 0.8, list = FALSE)
train.data  <- marketing[training.samples, ]
test.data <- marketing[-training.samples, ]
# Build the model
model <- lm(sales ~., data = train.data)
# Summarize the model
summary(model)
# Make predictions
predictions <- model %>% predict(test.data)
# Model performance
# (a) Prediction error, RMSE
RMSE(predictions, test.data$sales)
# (b) R-square
R2(predictions, test.data$sales)
#---------------Simple linear regression-----------------------
model <- lm(sales ~ youtube, data = train.data)
summary(model)
#p value of the both intercept and slope are lesser than 0.05 we conclude that intercept(8.439112) and slope(0.04753) are not equals to zero.
#Therefore, the regression coefficients(i.e. slope and intercept) are significant.
#As we have r square as 0.6119 it indicates that sales is 61.19% related to the youtube
newdata <- data.frame(youtube = c(0,  1000))
model %>% predict(newdata)
#---------------Multiple linear regression------------------
#y = b0 + b1*x1 + b2*x2 + b3*x3
#"b_j" can be interpreted as the average effect on y of a one unit increase in "x_j", holding all other predictors fixed.
model <- lm(sales ~., data = train.data)
summary(model)$coef
#Estimate: the intercept (b0) and the beta coefficient estimates associated to each predictor variable
#Std.Error: the standard error of the coefficient estimates. This represents the accuracy of the coefficients. The larger the standard error, the less confident we are about the estimate.
#t value: the t-statistic, which is the coefficient estimate (column 2) divided by the standard error of the estimate (column 3)
#Pr(>|t|): The p-value corresponding to the t-statistic. The smaller the p-value, the more significant the estimate is.
# New advertising budgets
newdata <- data.frame(
  youtube = 2000, facebook = 1000,
  newspaper = 1000
)
# Predict sales values
model %>% predict(newdata)
summary(model)
#------------------------Fitted values and residuals------------------------http://www.sthda.com/english/articles/39-regression-model-diagnostics/161-linear-regression-assumptions-and-diagnostics-in-r-essentials/
#describing regression assumptions and regression diagnostics, we start by explaining two key concepts in regression analysis: Fitted values and residuals errors
#The fitted (or predicted) values are the y-values that you would expect for the given x-values according to the built regression model
#the observed (or measured) sale values can be different from the predicted sale values. The difference is called the residual errors, represented by a vertical red lines.
#you can easily augment your data to add fitted values and residuals by using the function augment() [broom package]
model.diag.metrics <- augment(model)     #model <- lm(sales ~., data = train.data)
head(model.diag.metrics)
#youtube: the invested youtube advertising budget
#sales: the observed sale values
#.fitted: the fitted sale values
#.resid: the residual errors
#residuals error (in red color) between observed values and the fitted regression line.
#Each vertical red segments represents the residual error between an observed sale value and the corresponding predicted (i.e. fitted) value.
ggplot(model.diag.metrics, aes(youtube, sales)) +
geom_point() +
  stat_smooth(method = lm, se = FALSE) +
  geom_segment(aes(xend = youtube, yend = .fitted), color = "red", size = 0.3)
#---------------------------check Regression assumptions-----------------------
#You should make sure that these assumptions hold true for your data.
#Linearity of the data. The relationship between the predictor (x) and the outcome (y) is assumed to be linear.
#Normality of residuals. The residual errors are assumed to be normally distributed.
#Homogeneity of residuals variance. The residuals are assumed to have a constant variance (homoscedasticity)
#Independence of residuals error terms.
#you should check whether or not these assumptions hold true. Potential problems include:
#Non-linearity of the outcome - predictor relationships
#Heteroscedasticity: Non-constant variance of error terms.
#Presence of influential values in the data that can be:
 #       Outliers: extreme values in the outcome (y) variable
 #       High-leverage points: extreme values in the predictors (x) variable
#-----------------------------Regression diagnostics {reg-diag}--------------------------
#Regression diagnostics plots can be created using the R base function plot() or the autoplot() function [ggfortify package]
par(mfrow = c(2, 2))
plot(model)
library(ggfortify)
autoplot(model)
#-------1)::Residuals vs Fitted. Used to check the linear relationship assumptions. A horizontal line, without distinct patterns is an indication for a linear relationship, what is good.
plot(model, 1)
# the residual plot will show no fitted pattern. That is, the red line should be approximately horizontal at zero. The presence of a pattern may indicate a problem with some aspect of the linear model.
#there is no pattern in the residual plot. This suggests that we can assume linear relationship between the predictors and the outcome variables.
#Note that, if the residual plot indicates a non-linear relationship in the data, then a simple approach is to use non-linear transformations of the predictors, such as log(x), sqrt(x) and x^2, in the regression model.
#here in residuals vs fitted plot the red line is almost lying near to zero residual value and is almost horizontal and all the fitted values are scattered around it without any systematic relationship. LINEARITY is met on residuals

#---------2)Normal Q-Q. Used to examine whether the residuals are normally distributed. It's good if residuals points follow the straight dashed line.
#The QQ plot of residuals can be used to visually check the normality assumption. The normal probability plot of residuals should approximately follow a straight line.
#all the points fall approximately along this reference line, so we can assume normality.
plot(model, 2)
#IN normal q-q plot drawn, the e=residuals are almost linearly distributed.(but lets check normaly futher using other tests) HOMOSCADESCITY IS MET on residuals.

#---------3)Scale-Location (or Spread-Location). Used to check the homogeneity of variance of the residuals (homoscedasticity). Horizontal line with equally spread points is a good indication of homoscedasticity. This is not the case in our example, where we have a heteroscedasticity problem.
plot(model, 3)
#In sales-location plot,all the residuals are scattered(i.e none of the points are clustered at one spot) HOMOSCADESCITY IS MET on residuals.
#if residuals are spread equally along the ranges of predictors. It's good if you see a horizontal line with equally spread points. In our example, this is not the case.
#It can be seen that the variability (variances) of the residual points increases with the value of the fitted outcome variable, suggesting non-constant variances in the residuals errors (or heteroscedasticity).
#A possible solution to reduce the heteroscedasticity problem is to use a log or square root transformation of the outcome variable (y).
model2 <- lm(log(sales) ~ youtube, data = marketing)
plot(model2, 3)

#------------4)Residuals vs Leverage. Used to identify influential cases, that is extreme values that might influence the regression results when included or excluded from the analysis. This plot will be described further in the next sections.
#Outliers:::
#An outlier is a point that has an extreme outcome variable value. The presence of outliers may affect the interpretation of the model, because it increases the RSE.
#Outliers can be identified by examining the standardized residual (or studentized residual), which is the residual divided by its estimated standard error. Standardized residuals can be interpreted as the number of standard errors away from the regression line.
#Observations whose standardized residuals are greater than 3 in absolute value are possible outliers (James et al. 2014).
#High leverage points::::
#A data point has high leverage, if it has extreme predictor x values. This can be detected by examining the leverage statistic or the hat-value. A value of this statistic above 2(p + 1)/n indicates an observation with high leverage (P. Bruce and Bruce 2017); where, p is the number of predictors and n is the number of observations.
#Outliers and high leverage points can be identified by inspecting the Residuals vs Leverage plot:
plot(model, 4)
#The plot above highlights the top 3 most extreme points (#26, #36 and #179), with a standardized residuals below -2. However, there is no outliers that exceed 3 standard deviations, what is good.
#Additionally, there is no high leverage point in the data. That is, all data points, have a leverage statistic below 2(p + 1)/n = 4/200 = 0.02.
#-------------5)checking normality on residuals----------------------
shapiro.test(model$residuals)
library(nortest)
ad.test(model$residuals)  #Anderson-Darling normality test
library(moments)
skewness(model$residuals)
kurtosis(model$residuals)
#Here the probability value of both shapiro wilk test and anderson darling test is more than 0.05 hence, we accept null hypothesis saying that the residual data is normally distributed
#we also have skewness nearly equal to zero and kurtosis nearly equal to 3 where we can say that residual data is normally distributed.
#therefore, NORMALITY IS MET on residuals
#----------------------6)checking independency on residuals----------------
#Here we check wther the residuals are correlated (dependent) or not correlated (independent) by using durbin watson test
library(car)
## Loading required package: carData
durbinWatsonTest(model)
#Here the probability value is grater than 0.05 so we accept null hypothesis saying that there is no correlation among residuals(i.e residuals are independent)
#Therefore INDEPENDENCY IS MET on residual
#----important information
#{LINEARITY is met on residuals     by residuals vs fitted plot}
#{HOMOSCADESCITY IS MET on residuals.   by sales-location plot,normal q-q plot drawn}
#{normality on residuals   by shapiro.test, Anderson-Darling normality test,skewness, kurtosis,  }
#{independency on residuals    by durbinWatsonTest}
#-----------------Influential values---------------------------
#An influential value is a value, which inclusion or exclusion can alter the results of the regression analysis. Such a value is associated with a large residual.
#Not all outliers (or extreme data points) are influential in linear regression analysis.
#Statisticians have developed a metric called Cook's distance to determine the influence of a value. This metric defines influence as a combination of leverage and residual size.
#A rule of thumb is that an observation has high influence if Cook's distance exceeds 4/(n - p - 1)(P. Bruce and Bruce 2017), where n is the number of observations and p the number of predictor variables.
#The Residuals vs Leverage plot can help us to find influential observations if any. On this plot, outlying values are generally located at the upper right corner or at the lower right corner. Those spots are the places where data points can be influential against a regression line.
# Cook's distance
plot(model, 4)
# Residuals vs Leverage
plot(model, 5)
#By default, the top 3 most extreme values are labelled on the Cook's distance plot. If you want to label the top 5 extreme values, specify the option id.n as follow:
#If you want to look at these top 3 observations with the highest Cook's distance in case you want to assess them further, type this R code:
model.diag.metrics %>%
  top_n(3, wt = .cooksd)
#note::When data points have high Cook's distance scores and are to the upper or lower right of the leverage plot, they have leverage meaning they are influential to the regression results. The regression results will be altered if we exclude those cases.
#In our example, the data don't present any influential points. Cook's distance lines (a red dashed line) are not shown on the Residuals vs Leverage plot because all points are well inside of the Cook's distance lines.

#----------------model accuracy--------------------
library(DMwR)
## Loading required package: lattice
## Loading required package: grid
regr.eval(marketing$sales,model$fitted.values)
#In the above values the mean absolute percentage error is 20.57 i.e 79.43 accuracy from the values we can say that model is good

#you should continue the diagnostic by checking how well the model fits the data. This process is also referred to as the goodness-of-fit
#The overall quality of the linear regression fit can be assessed using the following three quantities, displayed in the model summary:
summary(model)
  #1)Residual standard error (RSE).
#represents roughly the average difference between the observed outcome values and the predicted values by the model.
# The lower the RSE the best the model fits to our data.
#Dividing the RSE by the average value of the outcome variable will give you the prediction error rate, which should be as small as possible.
#In our example, using only youtube and facebook predictor variables, the RSE = 2.11, meaning that the observed sales values deviate from the predicted values by approximately 2.11 units in average.
#This corresponds to an error rate of 2.11/mean(train.data$sales) = 2.11/16.77 = 13%, which is low
    #2) R-squared and Adjusted R-squared:
#a problem with the R2, is that, it will always increase when more variables are added to the model, even if those variables are only weakly associated with the outcome 
#The adjustment in the "Adjusted R Square" value in the summary output is a correction for the number of x variables included in the predictive model.
      #3)F-Statistic:
# It assess whether at least one predictor variable has a non-zero coefficient.
#The F-statistic becomes more important once we start using multiple predictors as in multiple linear regression.
#--------------------Making predictions------------------------
# Make predictions
predictions <- model %>% predict(test.data)
# Model performance
# (a) Compute the prediction error, RMSE
RMSE(predictions, test.data$sales)
#The prediction error RMSE (Root Mean Squared Error), representing the average difference between the observed known outcome values in the test data and the predicted outcome values by the model. The lower the RMSE, the better the model.
# (b) Compute R-square
R2(predictions, test.data$sales)
#From the output above, the R2 is 0.93, meaning that the observed and the predicted outcome values are highly correlated, which is very good.
#The prediction error RMSE is 1.58, representing an error rate of 1.58/mean(test.data$sales) = 1.58/17 = 9.2%, which is good.
#--------------------visulization----------------------------
#linear regression assumes a linear relationship between the outcome and the predictor variables. This can be easily checked by creating a scatter plot of the outcome variable vs the predictor variable.
ggplot(marketing, aes(x = youtube, y = sales)) +
  geom_point() +
  stat_smooth()
#=============================================================================
#Let's show now another example, where the data contain two extremes values with potential influence on the regression results:
df2 <- data.frame(
  x = c(marketing$youtube, 500, 600),
  y = c(marketing$sales, 80, 100)
)
model2 <- lm(y ~ x, df2)
#Create the Residuals vs Leverage plot of the two models:
# Cook's distance
plot(model2, 4)
# Residuals vs Leverage
plot(model2, 5)
#On the Residuals vs Leverage plot, look for a data point outside of a dashed line, Cook's distance. When the points are outside of the Cook's distance, this means that they have high Cook's distance scores.
# In this case, the values are influential to the regression results. The regression results will be altered if we exclude those cases.
#In the above example 2, two data points are far beyond the Cook's distance lines. The other residuals appear clustered on the left. The plot identified the influential observation as #201 and #202. If you exclude these points from the analysis, the slope coefficient changes from 0.06 to 0.04 and R2 from 0.5 to 0.6. Pretty big impact!
#==================================================================================
#----------------------------possible solution------------------------------
#A non-linear relationships between the outcome and the predictor variables. When facing to this problem, one solution is to include a quadratic term, such as polynomial terms or log transformation. See Chapter @ref(polynomial-and-spline-regression).

#Existence of important variables that you left out from your model. Other variables you didn't include (e.g., age or gender) may play an important role in your model and data. See Chapter @ref(confounding-variables).

#Presence of outliers. If you believe that an outlier has occurred due to an error in data collection and entry, then one solution is to simply remove the concerned observation.
# follow non linear regression
# follow Confounding Variable