#help(predict.lm)
regressor = lm(formula = Salary ~ YearsExperience,
               data = training_set)
confint(regressor,level = .99)# confidence interval range
# to derive confidence interval and prediction interval of linear model----complicated in multiple linear model
predict.lm(regressor,training_set,interval = "predict", level = .99)
# to find lower and upper bound value(confidence interval have narrow interval then prediction because additional level of uncertinity)
predict.lm(regressor,Salary_Data,interval = "confidence", level = .99)
detach(training_set)     # clean up
#-----------------------------------------
# for one YearExperience
newdata = data.frame(YearsExperience=3.0)
predict.lm(regressor,newdata,interval = "predict", level = .99)