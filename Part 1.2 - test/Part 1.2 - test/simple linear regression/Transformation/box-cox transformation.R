#  NORMALITY TRANSFORMATION
# if normality assumption does not hold
regressor = lm(formula = Salary ~ YearsExperience,
               data = Salary_Data)
plot(Salary_Data$YearsExperience,rstandard(regressor))
par(mfrow=c(1,1))# set margin
par("mar")# to check margin
hist(regressor$resid, margin = NULL)
qqnorm(regressor$resid)
qqline(regressor$resid)
install.packages("moments")
library(moments)
skewness(regressor$resid)
library(MASS)
b=boxcox(Salary ~ YearsExperience,data = Salary_Data)
b=boxcox(Salary ~ YearsExperience,data = Salary_Data)
lemda=Salary_Data$YearsExperience
lemda
lik= Salary_Data$Salary
lik
regressor
cb=cbind(lemda,lik)
cb
cb[order(-lik),]
regressor = lm(Salary^lemda ~ YearsExperience,
               data = Salary_Data)