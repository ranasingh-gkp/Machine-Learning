#import data
#Let us look at the interaction plot
interaction.plot(Randomized_Block_Design$typeOfTip,Randomized_Block_Design$testCoupon,Randomized_Block_Design$hardness)
#box plot
boxplot(hardness~typeOfTip, data = Randomized_Block_Design)
#Let us now run the analysis of variance on the data, we will include the blocking variable in the analysis.
#the formula to be used in R is hardness~typeOfTip+testCoupon.
anova(aov(hardness ~ factor(typeOfTip)+factor(testCoupon), data = Randomized_Block_Design))
#A plot of the residuals should not show any pattern since the residuals are assumed to be independently distributed for analysis of variance. Here's the plot of the residuals
plot(resid(lm(hardness ~ factor(typeOfTip)+factor(testCoupon), data = Randomized_Block_Design)))
#A Quantil-Quantile plot can be used to check the distribution as well. The plot also shows the presence of outliers
qqplot(lm(hardness ~ factor(typeOfTip)+factor(testCoupon), data = Randomized_Block_Design))
#Tukeys test can be used for pairwise comparison
fit=aov(hardness~factor(typeOfTip)+factor(testCoupon),data = Randomized_Block_Design)
TukeyHSD(fit,ordered="TRUE")
#-------------------------------------
#method to check to equality of variance.
summary(lm(abs(fit$res)~typeOfTip, data = Randomized_Block_Design))
#Since the p-value is large, difference in variance cannot be stated.
