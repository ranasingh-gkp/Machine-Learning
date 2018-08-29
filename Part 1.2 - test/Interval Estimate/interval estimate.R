#--------------------------------------------
#Interval estimate
#--------------------------------------------
#Point Estimate of Population Mean
#---------------------------------------------
library(MASS)
Salary.survey = Salary_Data$Salary
mean(Salary.survey , na.rm=TRUE)  # skip missing values
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#----------------------------------------------------
#Interval Estimate of Population Mean with Known Variance
#----------------------------------------------------
library(MASS)
#We first filter out missing values in survey$Height with the na.omit function, and save it in height.response.
height.response = na.omit(survey$Height)
#Then we compute the standard error of the mean.
n = length(height.response) 
sigma = 9.48                   # population standard deviation 
sem = sigma/sqrt(n); sem       # standard error of the mean 
# the 95% confidence level would imply the 97.5th percentile of the normal distribution at the upper tail
#Therefore, z?????2 is given by qnorm(.975). We multiply it with the standard error of the mean sem and get the margin of error.
E = qnorm(.975)* sem; E  # margin of error
#We then add it up with the sample mean, and find the confidence interval as told.
xbar = mean(height.response)   # sample mean 
xbar + c(-E, E)

#Alternative Solution
install.packages("TeachingDemos")
library(TeachingDemos)         # load TeachingDemos package 
z.test(Salary.survey, sd=sigma) #One Sample z???test 

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#Interval Estimate of Population Mean with Unknown Variance
#------------------------------------------------
library(MASS)
#We first filter out missing values in survey$Height with the na.omit function, and save it in height.response.
height.response = na.omit(survey$Height)
#Then we compute the sample standard deviation.

n = length(height.response) 
s = sd(height.response)        # sample standard deviation 
SE = s/sqrt(n); SE             # standard error estimate 
# the 95% confidence level would imply the 97.5th percentile of the normal distribution at the upper tail
#Therefore, t?????2 is given by qt(.975, df=n-1). We multiply it with the standard error estimate SE and get the margin of error.
E = qt(.975, df=n-1)*SE; E     # margin of error
#We then add it up with the sample mean, and find the confidence interval as told.
xbar = mean(height.response)   # sample mean 
xbar + c(-E, E)

#Alternative Solution
#we can apply the t.test function in the built-in stats package.
t.test(Salary.survey) #One Sample t???test

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#Sampling Size of Population Mean
#-------------------------------------------------------------
#Assume the population standard deviation ?? of the student height in survey is 9.48. Find the sample size needed to achieve a 1.2 centimeters margin of error at 95% confidence leve

zstar = qnorm(.975) 
sigma = 9.48 
E = 1.2 
zstar^2 * sigma^2/ E^2
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#Point Estimate of Population Proportion
#-----------------------------------------------------------
#We first filter out missing values in survey$Sex with the na.omit function, and save it in gender.response.
library(MASS)                  # load the MASS package 
gender.response = na.omit(survey$Sex) 
n = length(gender.response)    # valid responses count
#To find out the number of female students, we compare gender.response with the factor 'Female', and compute the sum. Dividing it by n gives the female student proportion in the sample survey.
k = sum(gender.response == "Female") 
pbar = k/n; pba

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#Interval Estimate of Population Proportion
#-----------------------------------------------------------
#Compute the margin of error and estimate interval for the female students proportion in survey at 95% confidence level.
#We first filter out missing values in survey$Sex with the na.omit function, and save it in gender.response.
library(MASS)                  # load the MASS package 
gender.response = na.omit(survey$Sex) 
n = length(gender.response)    # valid responses count
#To find out the number of female students, we compare gender.response with the factor 'Female', and compute the sum. Dividing it by n gives the female student proportion in the sample survey.
k = sum(gender.response == "Female") 
pbar = k/n; pba
#Then we estimate the standard error
SE = sqrt(pbar*(1-pbar)/n); SE     # standard error
E = qnorm(.975)*SE; E              # margin of error
#Combining it with the sample proportion, we obtain the confidence interval.
pbar + c(-E, E)

#Alternative Solution
prop.test(k, n) #1???sample proportions test without continuity correction

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#Sampling Size of Population Proportion
#--------------------------------------------------
 zstar = qnorm(.975) 
p = 0.5 
E = 0.05 
zstar^2 * p * (1-p) / E^2 


