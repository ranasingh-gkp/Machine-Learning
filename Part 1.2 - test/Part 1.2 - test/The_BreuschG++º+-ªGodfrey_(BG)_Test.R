#bgtest(formula, order = 1, order.by = NULL, type = c("Chisq", "F"),data = list(), fill = 0)
#the type of test statistic to be returned. Either "Chisq" for the Chi-squared test statistic or "F" for the F test statistic.
bgtest(lm(pred ~ .,data=data_all))
coeftest(bgtest(lm(pred ~ ., data=data_all)))

         