#Correlation Test Between Two Variables
#-------------------------------
install.packages("ggpubr")
library("ggpubr")
#There are different methods to perform correlation analysis:
#Pearson correlation (r)::, which measures a linear dependence between two variables (x and y). It's also known as a parametric correlation test because it depends to the distribution of the data. It can be used only when x and y are from normal distribution. The plot of y = f(x) is named the linear regression curve.
          #If the p-value is < 5%, then the correlation between x and y is significant.
#Kendall tau and Spearman rho,:: which are rank-based correlation coefficients (non-parametric)
#---------------------------
#simplified formet::
#cor(x, y, method = c("pearson", "kendall", "spearman"))
#cor.test(x, y, method=c("pearson", "kendall", "spearman"))
#If your data contain missing values, use the following R code to handle missing values by case-wise deletion.
#cor(x, y,  method = "pearson", use = "complete.obs")
#---------------------------
my_data <- mtcars
head(my_data, 6)
#visualize your data
library("ggpubr")
ggscatter(my_data, x = "mpg", y = "wt", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Miles/(US) gallon", ylab = "Weight (1000 lbs)")
#Is the covariation linear? Yes, form the plot above, the relationship is linear. In the situation where the scatter plots show curved patterns, we are dealing with nonlinear association between the two variables.

#Are the data from each of the 2 variables (x, y) follow a normal distribution?
          #Use Shapiro-Wilk normality test -> R function: shapiro.test()
        #and look at the normality plot -> R function: ggpubr::ggqqplot()
#Shapiro-Wilk test can be performed as follow:
    #Null hypothesis: the data are normally distributed
  #Alternative hypothesis: the data are not normally distributed
# Shapiro-Wilk normality test for mpg
shapiro.test(my_data$mpg) # => p = 0.1229
# Shapiro-Wilk normality test for wt
shapiro.test(my_data$wt) ## => p = 0.09
#RESULT::From the output, the two p-values are greater than the significance level 0.05 implying that the distribution of the data are not significantly different from normal distribution. In other words, we can assume the normality.
#------OR Visual inspection of the data normality using Q-Q plots (quantile-quantile plots). Q-Q plot draws the correlation between a given sample and the normal distribution.
library("ggpubr")
# mpg
ggqqplot(my_data$mpg, ylab = "MPG")
# wt
ggqqplot(my_data$wt, ylab = "WT")
#From the normality plots, we conclude that both populations may come from normal distributions.
#NOTE::Note that, if the data are not normally distributed, it's recommended to use the non-parametric correlation, including Spearman and Kendall rank-based correlation tests.
#-------------Pearson correlation test
res <- cor.test(my_data$wt, my_data$mpg,  method = "pearson")
res
#RESULT::The p-value of the test is 1.29410^{-10}, which is less than the significance level alpha = 0.05. We can conclude that wt and mpg are significantly correlated with a correlation coefficient of -0.87 and p-value of 1.29410^{-10} .

#-------------Kendall rank correlation test(NOT NORMALLY DISTRIBUTED)
#The Kendall rank correlation coefficient or Kendall's tau statistic is used to estimate a rank-based measure of association. 
#This test may be used if the data do not necessarily come from a bivariate normal distribution.
res2 <- cor.test(my_data$wt, my_data$mpg,  method="kendall")
res2  #tau is the Kendall correlation coefficient.
#RESULT::The correlation coefficient between x and y are -0.7278 and the p-value is 6.70610^{-9}.
#--------------Spearman rank correlation coefficient
#Spearman's rho statistic is also used to estimate a rank-based measure of association. 
#This test may be used if the data do not come from a bivariate normal distribution.
res2 <-cor.test(my_data$wt, my_data$mpg,  method = "spearman")
res2     #rho is the Spearman's correlation coefficient.
#RESULT::The correlation coefficient between x and y are -0.8864 and the p-value is 1.48810^{-11}.
#==========================Correlation matrix==================
# Load data
data("mtcars")
my_data <- mtcars[, c(1,3,4,5,6,7)]
# print the first 6 rows
head(my_data, 6)
#Compute correlation matrix
res <- cor(my_data)
round(res, 2)
#-------Correlation matrix with significance levels (p-value)
#The function rcorr() [in Hmisc package] can be used to compute the significance levels for pearson and spearman correlations.
install.packages("Hmisc")
library("Hmisc")
res2 <- rcorr(as.matrix(my_data))
res2

# --------------flattenCorrMatrix

# cormat : matrix of the correlation coefficients
# pmat : matrix of the correlation p-values
flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}
library(Hmisc)
res2<-rcorr(as.matrix(mtcars[,1:7]))
flattenCorrMatrix(res2$r, res2$P)
#------------------Visualize correlation matrix--------------
#---Use symnum() function: Symbolic number coding
#SIMPLIFIED FORMET
#symnum(x, cutpoints = c(0.3, 0.6, 0.8, 0.9, 0.95), symbols = c(" ", ".", ",", "+", "*", "B"), abbr.colnames = TRUE)
#cutpoints: correlation coefficient cutpoints. The correlation coefficients between 0 and 0.3 are replaced by a space (" "); correlation coefficients between 0.3 and 0.6 are replace by"."; etc .
symnum(res, abbr.colnames = FALSE)

#----Use corrplot() function: Draw a correlogram
install.packages("corrplot")
library(corrplot)
#The correlation matrix is reordered according to the correlation coefficient using "hclust" method.
#tl.col (for text label color) and tl.srt (for text label string rotation) are used to change text colors and rotations.
#Possible values for the argument type are : "upper", "lower", "full"
corrplot(res, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45)
#Positive correlations are displayed in blue and negative correlations in red color. Color intensity and the size of the circle are proportional to the correlation coefficients. 
# In the right side of the correlogram, the legend color shows the correlation coefficients and the corresponding colors.
# Specialized the insignificant value according to the significant level
corrplot(res, type="upper", order="hclust",p.mat = NULL, sig.level = 0.01)
# Leave blank on no significant coefficient
corrplot(res, type="upper", order="hclust", p.mat = NULL, sig.level = 0.01, insig = "blank")
#above figure, correlations with p-value > 0.01 are considered as insignificant. In this case the correlation coefficient values are leaved blank or crosses are added.

#-----Use chart.Correlation(): Draw scatter plots
install.packages("PerformanceAnalytics")
library("PerformanceAnalytics")
my_data <- mtcars[, c(1,3,4,5,6,7)]
chart.Correlation(my_data, histogram=TRUE, pch=19)
#In the above plot:
    #The distribution of each variable is shown on the diagonal.
    #On the bottom of the diagonal : the bivariate scatter plots with a fitted line are displayed
    #On the top of the diagonal : the value of the correlation plus the significance level as stars
    #Each significance level is associated to a symbol : p-values(0, 0.001, 0.01, 0.05, 0.1, 1) <=> symbols("***", "**", "*", ".", " ")

