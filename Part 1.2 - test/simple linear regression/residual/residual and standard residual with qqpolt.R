#help(resid)
regressor.lm = lm(formula = Salary ~ YearsExperience,
                  data = Salary_Data)
regressor.res= resid(regressor.lm)#residual
regressor.stdres = rstandard(regressor.lm)#standard residual
plot(Salary_Data$YearsExperience, eruption.stdres, 
     ylab="Residuals", xlab="YearsExperience", 
     main="Salary_Data")
abline(0, 0) # the horizon
#The residual data of the simple linear regression model is the difference between the observed data of the dependent variable y and the fitted values y.

#Residual = y- ^y
#QQplot
qqnorm(regressor.stdres, 
        ylab="Standardized Residuals", 
        xlab="Normal Scores", 
        main="Old Faithful Eruptions") 
qqline(regressor.stdres)
