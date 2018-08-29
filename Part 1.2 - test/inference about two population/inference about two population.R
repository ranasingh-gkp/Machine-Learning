#Population Mean Between Two Matched Samples
#--------------------------------------------
library(MASS)         # load the MASS package 
head(immer)
t.test(immer$Y1, immer$Y2, paired=TRUE)  #Paired t-test 

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#Population Mean Between Two Independent Samples
head(mtcars)
L = mtcars$am == 0
mpg.auto = mtcars[L,]$mpg
mpg.auto   # automatic transmission mileage
#By applying the negation of L, we can find the gas mileage for manual transmission
mpg.manual = mtcars[!L,]$mpg
mpg.manual                  # manual transmission mileage
#We can now apply the t.test function to compute the difference in means of the two sample data.
t.test(mpg.auto, mpg.manual)  #Welch Two Sample t-test

#Alternative Solution
t.test(mpg ~ am, data=mtcars)  #Welch Two Sample t-test

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.
#Comparison of Two Population Proportions
#-----------------------------------------------------
library(MASS)         # load the MASS package 
head(quine)
table(quine$Eth, quine$Sex)
#We apply the prop.test function to compute the difference in female proportions. The Yates's continuity correction is disabled for pedagogical reasons.
prop.test(table(quine$Eth, quine$Sex), correct=FALSE)#2-sample test for equality of proportions without continuity correction
