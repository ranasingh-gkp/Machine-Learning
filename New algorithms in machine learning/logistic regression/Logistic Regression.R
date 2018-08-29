#Logistic Regression
#http://www.sthda.com/english/articles/36-classification-methods-essentials/148-logistic-regression-assumptions-and-diagnostics-in-r/
#-------------------------------
#Logistic regression is used to predict the class (or category) of individuals based on one or multiple predictor variables (x). 
#It is used to model a binary outcome, that is a variable, which can have only two possible values: 0 or 1, yes or no, diseased or non-diseased.
#Logistic regression does not return directly the class of observations. It allows us to estimate the probability (p) of class membership.
#The probability will range between 0 and 1. You need to decide the threshold probability at which the category flips from one to the other. By default, this is set to p = 0.5, but in reality it should be settled based on the analysis purpose.
#------------------------
#---------------------------Logistic function-----------------------
#The standard logistic regression function, for predicting the outcome of an observation given a predictor variable (x),
#is an s-shaped curve defined as p = exp(y) / [1 + exp(y)] (James et al. 2014). This can be also simply written as p = 1/[1 + exp(-y)],
#p is the probability of event to occur (1) given x. Mathematically, this is written as p(event=1|x) and abbreviated asp(x), sopx = 1/[1 + exp(-(b0 + b1*x))]`
#it can be demonstrated that p/(1-p) = exp(b0 + b1*x). By taking the logarithm of both sides, the formula becomes a linear combination of predictors: log[p/(1-p)] = b0 + b1*x.
#When you have multiple predictor variables, the logistic function looks like: log[p/(1-p)] = b0 + b1*x1 + b2*x2 + ... + bn*xn
#The quantity log[p/(1-p)] is called the logarithm of the odd, also known as log-odd or logit.
#The odds reflect the likelihood that the event will occur. It can be seen as the ratio of "successes" to "non-successes". Technically, odds are the probability of an event divided by the probability that the event will not take place (P. Bruce and Bruce 2017).
#Note that, the probability can be calculated from the odds as p = Odds/(1 + Odds).
library(tidyverse)  #tidyverse for easy data manipulation and visualization
library(caret)      #caret for easy machine learning workflow
theme_set(theme_bw())
#-------------------------Preparing the data----------------------
#Logistic regression works for a data that contain continuous and/or categorical predictor variables.
#Performing the following steps might improve the accuracy of your model
#           Remove potential outliers
#           Make sure that the predictor variables are normally distributed. If not, you can use log, root, Box-Cox transformation.
#           Remove highly correlated predictors to minimize overfitting. The presence of highly correlated predictors might lead to an unstable model solution.
# Load the data and remove NAs
install.packages("mlbench")
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
#-----------------------------Computing logistic regression----------------
#The R function glm(), for generalized linear model, can be used to compute logistic regression.
#You need to specify the option family = binomial, which tells to R that we want to fit logistic regression.
# Fit the model
model <- glm( diabetes ~., data = train.data, family = binomial)
# Summarize the model
summary(model)
# Make predictions
probabilities <- model %>% predict(test.data, type = "response")
predicted.classes <- ifelse(probabilities > 0.5, "pos", "neg")
# Model accuracy
mean(predicted.classes == test.data$diabetes)
#-------------------------------Simple logistic regression-------------------
#The simple logistic regression is used to predict the probability of class membership based on one single predictor variable.
#model to predict the probability of being diabetes-positive based on the plasma glucose concentration:
model <- glm( diabetes ~ glucose, data = train.data, family = binomial)
summary(model)$coef
#The logistic equation can be written as p = exp(-6.32 + 0.043*glucose)/ [1 + exp(-6.32 + 0.043*glucose)].
# Using this formula, for each new glucose plasma concentration value, you can predict the probability of the individuals in being diabetes positive.
#Predictions can be easily made using the function predict(). Use the option type = "response" to directly obtain the probabilities
newdata <- data.frame(glucose = c(20,  180))
newdata
probabilities <- model %>% predict(newdata, type = "response")
predicted.classes <- ifelse(probabilities > 0.5, "pos", "neg")
head(predicted.classes)
#The logistic function gives an s-shaped probability curve illustrated as follow:
train.data %>%                  #visulization
  mutate(prob = ifelse(diabetes == "pos", 1, 0)) %>%
  ggplot(aes(glucose, prob)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "glm", method.args = list(family = "binomial")) +
  labs(
    title = "Logistic Regression Model", 
    x = "Plasma Glucose Concentration",
    y = "Probability of being diabete-pos"
  )
#------------------------------------Logistic regression diagnostics---------------------
#-----------Linearity assumption
#we'll check the linear relationship between continuous predictor variables and the logit of the outcome. This can be done by visually inspecting the scatter plot between each predictor and the logit values.
#Remove qualitative variables from the original data frame and bind the logit values to the data:
# Select only numeric predictors
mydata <- PimaIndiansDiabetes2 %>%
  dplyr::select_if(is.numeric) 
predictors <- colnames(mydata)
# Bind the logit and tidying the data for plot
install.packages("dplyr")
library(dplyr)
mydata <- mydata %>%
  mutate(logit = log(probabilities/(1-probabilities))) %>%
  gather(key = "predictors", value = "predictor.value", -logit)
#Create the scatter plots:
ggplot(mydata, aes(logit, predictor.value))+
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") + 
  theme_bw() + 
  facet_wrap(~predictors, scales = "free_y")
#The smoothed scatter plots show that variables glucose, mass, pregnant, pressure and triceps are all quite linearly associated with the diabetes outcome in logit scale.
#The variable age and pedigree is not linear and might need some transformations. If the scatter plot shows non-linearity, you need other methods to build the model such as including 2 or 3-power terms, fractional polynomials and spline function (Chapter @ref(polynomial-and-spline-regression)).
#--------------Influential values 
#Influential values are extreme individual data points that can alter the quality of the logistic regression model.
#The most extreme values in the data can be examined by visualizing the Cook's distance values. Here we label the top 3 largest values:
plot(model, which = 4, id.n = 3)
#Note that, not all outliers are influential observations. To check whether the data contains potential influential observations, the standardized residual error can be inspected.
#The following R code computes the standardized residuals (.std.resid) and the Cook's distance (.cooksd) using the R function augment() [broom package].
# Extract model results
install.packages("broom")
library(broom)
model.data <- augment(model) %>% 
  mutate(index = 1:n()) 
model.data %>% top_n(3, .cooksd)   #data for the top 3 largest values, according to the Cook's distance, can be displayed
ggplot(model.data, aes(index, .std.resid)) +    #Plot the standardized residuals:
  geom_point(aes(color = diabetes), alpha = .5) +
  theme_bw()
model.data %>%   #Filter potential influential data points with abs(.std.res) > 3:
  filter(abs(.std.resid) > 3)
#There is no influential observations in our data.
#When you have outliers in a continuous predictor, potential solutions include:
    #Removing the concerned records
    #Transform the data into log scale
    #Use non parametric methods
#-----------------Multicollinearity
#Multicollinearity is an important issue in regression analysis and should be fixed by removing the concerned variables. It can be assessed using the R function vif() [car package], which computes the variance inflation factors:
car::vif(model)
#As a rule of thumb, a VIF value that exceeds 5 or 10 indicates a problematic amount of collinearity. In our example, there is no collinearity: all variables have a value of VIF well below 5.

#----------------------------------Multiple logistic regression------------------
#The multiple logistic regression is used to predict the probability of class membership based on multiple predictor variables, as follow:
model <- glm( diabetes ~ glucose + mass + pregnant,data = train.data, family = binomial)
summary(model)$coef
#we want to include all the predictor variables available in the data set. 
model <- glm( diabetes ~., data = train.data, family = binomial)
summary(model)$coef
#Std.Error: the standard error of the coefficient estimates. This represents the accuracy of the coefficients. The larger the standard error, the less confident we are about the estimate.
#z value: the z-statistic, which is the coefficient estimate (column 2) divided by the standard error of the estimate (column 3)
#Pr(>|z|): The p-value corresponding to the z-statistic. The smaller the p-value, the more significant the estimate is.
#----------------------------Interpretation---------------------------
#It can be seen that only 5 out of the 8 predictors are significantly associated to the outcome. These include: pregnant, glucose, pressure, mass and pedigree.
#An important concept to understand, for interpreting the logistic beta coefficients, is the odds ratio.
#An odds ratio measures the association between a predictor variable (x) and the outcome variable (y). It represents the ratio of the odds that an event will occur (event = 1) given the presence of the predictor x (x = 1), compared to the odds of the event occurring in the absence of that predictor (x = 0).
#If the odds ratio is 2, then the odds that the event occurs (event = 1) are two times higher when the predictor x is present (x = 1) versus x is absent (x = 0).
#For example, the regression coefficient for glucose is 0.042. This indicate that one unit increase in the glucose concentration will increase the odds of being diabetes-positive by exp(0.042) 1.04 times.
# it can be noticed that some variables - triceps, insulin and age - are not statistically significant. Keeping them in the model may contribute to overfitting
#Therefore, they should be eliminated. This can be done automatically using statistical techniques, including stepwise regression and penalized regression methods.
model <- glm( diabetes ~ pregnant + glucose + pressure + mass + pedigree, 
              data = train.data, family = binomial)
#we have a small number of predictors (n = 9), we can select manually the most significant.
#-----------------------------------Making predictions-----------------------------
#The procedure is as follow:
#                 Predict the class membership probabilities of observations based on predictor variables
#                 Assign the observations to the class with highest probability score (i.e above 0.5)
probabilities <- model %>% predict(test.data, type = "response")
head(probabilities)

predicted.classes <- ifelse(probabilities > 0.5, "pos", "neg")
head(predicted.classes)
#contrasts() function indicates that R has created a dummy variable with a 1 for "pos" and "0" for neg. 
contrasts(test.data$diabetes)
#--------------------------------------Assessing model accuracy-------------------------
#The model accuracy is measured as the proportion of observations that have been correctly classified.
mean(predicted.classes == test.data$diabetes)
#The classification prediction accuracy is about 76%, which is good. The misclassification error rate is 24%.
