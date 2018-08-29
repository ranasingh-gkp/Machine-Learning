#linearity assumption
plot(X50_Startups[,1:5]) #scatter plot
#residual are scatter around the zero line which indicate that assumption of linearity hold
library(car)
fits=MODEL$fitted
resids=MODEL$res
cook=cooks.distance(MODEL)
par(mfrow =c(2,2))
plot(fits, resids, xlab = "fitted value", ylab = "residuals")
abline(0,0,col= "red")
qqplot(resids, ylab = "residuals", main = "")
hist(resids, ylab = "residuals", main = "", nclass=10,col="orange")
plot(cook, type="h", lwd=3,col="red",ylab = "cook's distance")