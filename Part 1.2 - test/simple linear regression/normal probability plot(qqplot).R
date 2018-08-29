install.packages("qqplot")
library(qqplot)
help(qqplot)
qqnorm(Salary_Data$YearsExperience)
qqline(Salary_Data$YearsExperience)
qqplot(Salary_Data$Salary,Salary_Data$YearsExperience,plot.it = TRUE)
# histogram also use to check normality