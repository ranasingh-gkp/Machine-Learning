install.packages("car")
library(car)
linearHypothesis(regressor,c(0,1),rhs=1)
help(pt)
help(linearHypothesis)
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#------------------------------------------------
#Lower Tail Test of Population Mean with Known Variance
#---------------------------------------------
#QUESTION-Suppose the manufacturer claims that the mean lifetime of a light bulb is more than 10,000 hours. In a sample of 30 light bulbs, it was found that they only last 9,900 hours on average. Assume the population standard deviation is 120 hours. At .05 significance level, can we reject the claim by the manufacturer?
#The null hypothesis of the lower tail test of the population mean can be expressed as follows:  ?? ??? ??0
xbar = 9900            # sample mean 
mu0 = 10000            # hypothesized value 
sigma = 120            # population standard deviation 
n = 30 
#z = (xbar???mu0)/(sigma/sqrt(n))
z = (xbar???mu0)/(sigma/sqrt(n)) #test statistics
z
#  We then compute the critical value at .05 significance level.
alpha = .05 
z.alpha = qnorm(1???alpha) 
(-z.alpha)  # # critical value 
#(since The test statistic -4.5644 is less than the critical value of -1.6449. Hence, at .05 significance level, we reject the claim that mean lifetime of a light bulb is above 10,000 hours.)

#Alternative Solution
#Instead of using the critical value, we apply the pnorm function to compute the lower tail p-value of the test statistic

pval = pnorm(z) 
pval   # lower tail p???value 
#As it turns out to be less than the .05 significance level, we reject the null hypothesis that ?? ??? 10000.
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#---------------------------------------------------
# Upper Tail Test of Population Mean with Known Variance
#---------------------------------------------------
#The null hypothesis of the upper tail test of the population mean can be expressed as follows:  ?? ??? ??0
#The null hypothesis is that ?? ??? 2. We begin with computing the test statistic.

xbar = 2.1             # sample mean 
mu0 = 2                # hypothesized value 
sigma = 0.25           # population standard deviation 
n = 35                 # sample size 
                      # test statistic 
#We then compute the critical value at .05 significance level.

#z = (xbar???mu0)/(sigma/sqrt(n))
z = (xbar???mu0)/(sigma/sqrt(n)) #test statistics
z
#  We then compute the critical value at .05 significance level.
alpha = .05 
alpha = .05 
z.alpha = qnorm(1???alpha) 
z.alpha                # critical value
#The test statistic 2.3664 is greater than the critical value of 1.6449. Hence, at .05 significance level, we reject the claim that there is at most 2 grams of saturated fat in a cookie.

#Alternative Solution
#Instead of using the critical value, we apply the pnorm function to compute the upper tail p-value of the test statistic

pval = pnorm(z, lower.tail=FALSE) 
pval                   # upper tail p???value
#As it turns out to be less than the .05 significance level, we reject the null hypothesis that ?? ??? 2

#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#--------------------------------------------------
#Two-Tailed Test of Population Mean with Known Variance
#-------------------------------------------------------
# The null hypothesis of the two-tailed test of the population mean can be expressed as follows:  ?? = ??0 where ??0 is a hypothesized value of the true population mean ??.
#z = (xbar???mu0)/(sigma/sqrt(n))
#Then the null hypothesis of the two-tailed test is to be rejected if z ??????z?????2 or z ??? z?????2 , where z?????2 is the 100(1 ??? ?????2) percentile of the standard normal distribution.
#The null hypothesis is that ?? = 15.4. We begin with computing the test statistic.

xbar = 14.6            # sample mean 
mu0 = 15.4             # hypothesized value 
sigma = 2.5            # population standard deviation 
n = 35                 # sample size 
z = (xbar-mu0)/(sigma/sqrt(n)) 
z                      # test statistic
#We then compute the critical values at .05 significance level.

alpha = .05 
z.half.alpha = qnorm(1-alpha/2) 
c(-z.half.alpha, z.half.alpha)
#The test statistic -1.8931 lies between the critical values -1.9600 and 1.9600. Hence, at .05 significance level, we do not reject the null hypothesis
#Alternative Solution
#Instead of using the critical value, we apply the pnorm function to compute the two tail p-value of the test statistic
pval = 2 * pnorm(z)    # lower tail 
pval                   # two???tailed p???value
#Since it turns out to be greater than the .05 significance level, we do not reject the null hypothesis

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#--------------------------------------------------
#Lower Tail Test of Population Mean with Unknown Variance
#----------------------------------------------------
#The null hypothesis of the lower tail test of the population mean can be expressed as follows:  ?? ??? ??0
#where ??0 is a hypothesized lower bound of the true population mean ??.
#Let us define the test statistic t in terms of the sample mean, the sample size and the sample standard deviation s :

##Then the null hypothesis of the lower tail test is to be rejected if t ??????t?? , where t?? is the 100(1 ??? ??) percentile of the Student t distribution with n ??? 1 degrees of freedom.
#The null hypothesis is that ?? ??? 10000. We begin with computing the test statistic.

xbar = 9900            # sample mean 
mu0 = 10000            # hypothesized value 
s = 125                # sample standard deviation 
n = 30                 # sample size 
t = (xbar-mu0)/(s/sqrt(n)) 
t                      # test statistic 
#We then compute the critical value at .05 significance level.

alpha = .05 
t.alpha = qt(1-alpha, df=n-1) 
(-t.alpha)               # critical value
#The test statistic -4.3818 is less than the critical value of -1.6991. Hence, at .05 significance level, we can reject the claim that mean lifetime of a light bulb is above 10,000 hours.
#Alternative Solution
#Instead of using the critical value, we apply the pt function to compute the lower tail p-value of the test statistic
pval = pt(t, df=n-1) 
pval                   # lower tail p???value
#As it turns out to be less than the .05 significance level, we reject the null hypothesis that ?? ??? 10000.

#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#-------------------------------------------------------------------------------

