#help(summary.lm)
regressor = lm(formula = Salary ~ YearsExperience,
               data = Salary_Data)
#Then we print out the F-statistics of the significance test with the summary function.
summary(regressor)
summary(eruption.lm)$r.squared