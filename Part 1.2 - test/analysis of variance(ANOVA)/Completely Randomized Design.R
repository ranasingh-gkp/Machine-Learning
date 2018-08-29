#Completely Randomized Design
#example:::A fast food franchise is test marketing 3 new menu items. To find out if they the same
#popularity, 18 franchisee restaurants are randomly chosen for participation in the study. In accordance 
#with the completely randomized design, 6 of the restaurants are randomly chosen to test market
#the first new menu item, another 6 for the second menu item, and the remaining 6 for the last 
#menu item.
df1 = read.table("Completely Randomized Design.txt", header=TRUE); df1 
#Concatenate the data rows of df1 into a single vector r 
r = c(t(as.matrix(df1))) # response data
r
#Assign new variables for the treatment levels and number of observations.
f = c("Item1", "Item2", "Item3")   # treatment levels 
k = 3                    # number of treatment levels 
n = 6                    # observations per treatment
#Create a vector of treatment factors that corresponds to each element of r in step 3 with the gl function
tm = gl(k, 1, n*k, factor(f))   # matching treatments 
tm
#Apply the function aov to a formula that describes the response r by the treatment factor tm
av = aov(r ~ tm)
summary(av)
#Since the p-value of 0.11 is greater than the .05 significance level, we do not reject the null hypothesis that the mean sales volume of the new menu items are all equal.
#=========================================================================
#problem::Create the response data in step 3 above along vertical columns instead of horizontal rows. Adjust the factor levels in step 5 accordingly.
#Concatenate the data column of df1 into a single vector r 
r = c(as.matrix(df1)) # response data
r
#Assign new variables for the treatment levels and number of observations.
f = c("Item1", "Item2", "Item3")   # treatment levels 
k = 3                    # number of treatment levels 
n = 6                    # observations per treatment
#Create a vector of treatment factors that corresponds to each element of r in step 3 with the gl function
tm = gl(k, 1, n*k, factor(f))   # matching treatments 
tm
#Apply the function aov to a formula that describes the response r by the treatment factor tm
av = aov(r ~ tm)
summary(av)
#Since the p-value of 0.671 is greater than the .05 significance level, we do not reject the null hypothesis that the mean sales volume of the new menu items are all equal.




