install.packages("dplyr")
library(dplyr)
data(ToothGrowth)
data(PlantGrowth)
ToothGrowth
PlantGrowth
set.seed(123)
# Show PlantGrowth
dplyr::sample_n(PlantGrowth, 10)
# PlantGrowth data structure
str(PlantGrowth)
# Show ToothGrowth
dplyr::sample_n(ToothGrowth, 10)
# ToothGrowth data structure
str(ToothGrowth)
ToothGrowth$dose <- as.factor(ToothGrowth$dose)
#------------------------------------------------------------
#Compute Bartlett's test in R
#---------
# It's adapted for normally distributed data.
#Bartlett's test with one independent variable:
bartlett.test(weight ~ group, data = PlantGrowth)
# there is no evidence to suggest that the variance in plant growth is statistically significantly different for the three treatment groups.
#-------------------
#Bartlett's test with multiple independent variables:
bartlett.test(len ~ interaction(supp,dose), data=ToothGrowth)
#-------------------------------------------------------------------
#Compute Levene's test in R
#----------------
# Levene's test is an alternative to Bartlett's test when the data is not normally distributed.
library(car)
# Levene's test with one independent variable
leveneTest(weight ~ group, data = PlantGrowth)
# Levene's test with multiple independent variables
leveneTest(len ~ supp*dose, data = ToothGrowth)
#-------------------------------------------------------------------
# Fligner-Killeen test in R
#The Fligner-Killeen test is one of the many tests for homogeneity of variances which is most robust against departures from normality.
fligner.test(weight ~ group, data = PlantGrowth)





