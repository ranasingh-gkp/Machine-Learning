#Transforming Data
#------------------------------
#Most parametric tests require that residuals be normally distributed and that the residuals be homoscedastic. 
#One approach when residuals fail to meet these conditions is to transform one or more variables to better follow a normal distribution.  Often, just the dependent variable in a model will need to be transformed.
#However, in complex models and multiple regression, it is sometimes helpful to transform both dependent and independent variables that deviate greatly from a normal distribution.
#To present means or other summary statistics, you might present the mean of transformed values, or back transform means to their original units.
#Some measurements in nature are naturally normally distributed.  Other measurements are naturally log-normally distributed.
#For right-skewed data-tail is on the right, positive skew-, common transformations include square root, cube root, and log.
#For left-skewed data-tail is on the left, negative skew-, common transformations include square root (constant - x), cube root (constant - x), and log (constant - x).
#Because log (0) is undefined-as is the log of any negative number-, when using a log transformation, a constant should be added to all values to make them all positive before transformation.  It is also sometimes helpful to add a constant when using other transformations.
if(!require(psych)){install.packages("car")}
if(!require(MASS)){install.packages("MASS")}
if(!require(rcompanion)){install.packages("rcompanion")}
Turbidity = c(1.0, 1.2, 1.1, 1.1, 2.4, 2.2, 2.6, 4.1, 5.0, 10.0, 4.0, 4.1, 4.2, 4.1, 5.1, 4.5, 5.0, 15.2, 10.0, 20.0, 1.1, 1.1, 1.2, 1.6, 2.2, 3.0, 4.0, 10.5)
Turbidity
library(rcompanion)

plotNormalHistogram(Turbidity)
qqnorm(Turbidity,
       ylab="Sample Quantiles for Turbidity")
qqline(Turbidity, 
       col="red")
#====================Square root transformation
#Since the data is right-skewed, we will apply common transformations for right-skewed data:  square root, cube root, and log.  The square root transformation improves the distribution of the data somewhat.
T_sqrt = sqrt(Turbidity)
library(rcompanion)
plotNormalHistogram(T_sqrt)
#===================Cube root transformation
#The cube root transformation is stronger than the square root transformation.

T_cub = sign(Turbidity) * abs(Turbidity)^(1/3)   # Avoid complex numbers for some cube roots

library(rcompanion)

plotNormalHistogram(T_cub)
#=====================Log transformation
#The log transformation is a relatively strong transformation.  Because certain measurements in nature are naturally log-normal.
T_log = log(Turbidity)

library(rcompanion)

plotNormalHistogram(T_log)
#=====================Tukey's Ladder of Powers transformation
#Here, I use the transformTukey function, which performs iterative Shapiro-Wilk tests, and finds the lambda value that maximizes the W statistic from those tests.
# In essence, this finds the power transformation that makes the data fit the normal distribution as closely as possible with this type of transformation.
#Left skewed values should be adjusted with (constant - value), to convert the skew to right skewed, and perhaps making all values positive.
#In some cases of right skewed data, it may be beneficial to add a constant to make all data values positive before transformation.  For large values, it may be helpful to scale values to a more reasonable range.
library(rcompanion)

T_tuk = transformTukey(Turbidity,plotit=FALSE)
library(rcompanion)

plotNormalHistogram(T_tuk)
#___Example of Tukey-transformed data in ANOVA
#Transforming the turbidity values to be more normally distributed, both improves the distribution of the residuals of the analysis and makes a more powerful test, lowering the p-value.
Input =("
Location Turbidity
        a        1.0
        a        1.2
        a        1.1
        a        1.1
        a        2.4
        a        2.2
        a        2.6
        a        4.1
        a        5.0
        a       10.0
        b        4.0
        b        4.1
        b        4.2
        b        4.1
        b        5.1
        b        4.5
        b        5.0
        b       15.2
        b       10.0
        b       20.0
        c        1.1
        c        1.1
        c        1.2
        c        1.6
        c        2.2
        c        3.0
        c        4.0
        c       10.5
        ")

Data = read.table(textConnection(Input),header=TRUE)
#-----Attempt ANOVA on un-transformed data
boxplot(Turbidity ~ Location,
        data = Data,
        ylab="Turbidity",
        xlab="Location")


model = lm(Turbidity ~ Location, 
           data=Data)

library(car)

Anova(model, type="II")
x = (residuals(model))
#Here, even though the analysis of variance results in a significant p-value (p = 0.03)
library(rcompanion)

plotNormalHistogram(x)
qqnorm(residuals(model),
       ylab="Sample Quantiles for residuals")
qqline(residuals(model), 
       col="red")
plot(fitted(model),
     residuals(model))
# the residuals deviate from the normal distribution enough to make the analysis invalid.  The plot of the residuals vs. the fitted values shows that the residuals are somewhat heteroscedastic, though not terribly so.
#-------ANOVA with Tukey-transformed data
library(rcompanion)

Data$Turbidity_tuk = transformTukey(Data$Turbidity,plotit=FALSE)
boxplot(Turbidity_tuk ~ Location,
        data = Data,
        ylab="Tukey-transformed Turbidity",
        xlab="Location")
model = lm(Turbidity_tuk ~ Location, 
           data=Data)

library(car)

Anova(model, type="II")
# the test is more powerful as indicated by the lower p-value (p = 0.005) than with the untransformed data.
#making the F-test more appropriate
x = residuals(model)

library(rcompanion)

plotNormalHistogram(x)
qqnorm(residuals(model),
       ylab="Sample Quantiles for residuals")
qqline(residuals(model), 
       col="red")
plot(fitted(model),residuals(model))
#The plot of the residuals vs. the fitted values shows that the residuals are about as heteroscedastic as they were with the untransformed data.

#==========================Box-Cox transformation


#-----Box-Cox transformation for a single variable
library(MASS)

Box = boxcox(Turbidity ~ 1,              # Transform Turbidity as a single vector
             lambda = seq(-6,6,0.1)      # Try values -6 to 6 by 0.1
)

Cox = data.frame(Box$x, Box$y)            # Create a data frame with the results
Cox2 = Cox[with(Cox, order(-Cox$Box.y)),] # Order the new data frame by decreasing y

Cox2[1,]                                  # Display the lambda with the greatest log likelihood
lambda = Cox2[1, "Box.x"]                 # Extract that lambda
T_box = (Turbidity ^ lambda - 1)/lambda   # Transform the original data
library(rcompanion)

plotNormalHistogram(T_box)
qqnorm(T_box,
       ylab="Sample Quantiles for Turbidity")
qqline(T_box, 
       col="red")
#--------------Box-Cox transformation for ANOVA model
Input =("
Location Turbidity
        a        1.0
        a        1.2
        a        1.1
        a        1.1
        a        2.4
        a        2.2
        a        2.6
        a        4.1
        a        5.0
        a       10.0
        b        4.0
        b        4.1
        b        4.2
        b        4.1
        b        5.1
        b        4.5
        b        5.0
        b       15.2
        b       10.0
        b       20.0
        c        1.1
        c        1.1
        c        1.2
        c        1.6
        c        2.2
        c        3.0
        c        4.0
        c       10.5
        ")
Data = read.table(textConnection(Input),header=TRUE)
model = lm(Turbidity ~ Location, 
           data=Data)

library(car)

Anova(model, type="II")
x = residuals(model)

library(rcompanion)

plotNormalHistogram(x)
qqnorm(residuals(model),
       ylab="Sample Quantiles for residuals")
qqline(residuals(model), 
       col="red")
plot(fitted(model),
     residuals(model))
#-------Transform data
library(MASS)

Box = boxcox(Turbidity ~ Location,
             data = Data,
             lambda = seq(-6,6,0.1)
)

Cox = data.frame(Box$x, Box$y)

Cox2 = Cox[with(Cox, order(-Cox$Box.y)),]

Cox2[1,]

lambda = Cox2[1, "Box.x"]

Data$Turbidity_box = (Data$Turbidity ^ lambda - 1)/lambda   

boxplot(Turbidity_box ~ Location,
        data = Data,
        ylab="Box-Cox-transformed Turbidity",
        xlab="Location")
#--------Perform ANOVA and check residuals
model = lm(Turbidity_box ~ Location, 
           data=Data)

library(car)

Anova(model, type="II")
x = residuals(model)

library(rcompanion)

plotNormalHistogram(x)
qqnorm(residuals(model),
       ylab="Sample Quantiles for residuals")
qqline(residuals(model), 
       col="red")
plot(fitted(model),
     residuals(model))
# In cases where there are complex models or multiple regression, it may be helpful to transform both dependent and independent variables independently.
