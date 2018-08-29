# kuryosis
 library(e1071)                    # load e1071 
 wage_test = MEAN_HOURLY_WAGE_BY_EDUCATION$wage     # wage test function 
 kurtosis(wage_test)   # apply the kurtosis function
skewness(wage_test)
summary(wage_test)
plot(density(MEAN_HOURLY_WAGE_BY_EDUCATION$wage))
hist(MEAN_HOURLY_WAGE_BY_EDUCATION$wage, breaks=100)
qqnorm(MEAN_HOURLY_WAGE_BY_EDUCATION$wage)
qqline(MEAN_HOURLY_WAGE_BY_EDUCATION$wage)


library(ggplot2)
qplot(wage_test, geom = 'histogram', binwidth = 2) + xlab('wage_test')

install.packages("normtest")
library(normtest)
jb.norm.test(wage_test)
