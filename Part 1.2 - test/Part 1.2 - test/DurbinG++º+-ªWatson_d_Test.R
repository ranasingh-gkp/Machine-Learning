
library(car)
install.packages("car")
durbinWatsonTest(lm(pred ~ ., data=data_all))
-------------------------------------
install.packages("lmtest")
library(lmtest)
dwtest(lm(pred ~ ., data=data_all))
