#two way ANOVA test
#---------------------------------------------------------------------------------
#The grouping variables are also known as factors. The different categories (groups) of a factor are called levels. The number of levels can vary between factors. The level combinations of factors are called cell.
#When the sample sizes within cells are equal, we have the so-called balanced design. In this case the standard two-way ANOVA test can be applied.
#When the sample sizes within each level of the independent variables are not the same (case of unbalanced designs), the ANOVA test should be handled differently.
#-----------------------------------------------------------
#Compute two-way ANOVA test in R: balanced designs
data(ToothGrowth)
ToothGrowth
install.packages("dplyr")
# Show a random sample
set.seed(1234)
dplyr::sample_n(ToothGrowth, 10)
# Check the structure
str(ToothGrowth)
# Convert dose as a factor and recode the levels
# as "D0.5", "D1", "D2"
ToothGrowth$dose <- factor(ToothGrowth$dose, 
                       levels = c(0.5, 1, 2),
                       labels = c("D0.5", "D1", "D2"))#We want to know if tooth length depends on supp and dose.
#Generate frequency tables:
table(ToothGrowth$supp, ToothGrowth$dose)
#---------------------------------------
#Visualize your data
#--------------
install.packages("ggpubr")
# Box plot with multiple groups
# Plot tooth length ("len") by groups ("dose")
# Color box plot by a second group: "supp"
library("ggpubr")
ggboxplot(ToothGrowth, x = "dose", y = "len", color = "supp",
          palette = c("#00AFBB", "#E7B800"))
# Line plots with multiple groups
# Plot tooth length ("len") by groups ("dose")
# Color box plot by a second group: "supp"
# Add error bars: mean_se
# (other values include: mean_sd, mean_ci, median_iqr, ....)
library("ggpubr")
ggline(ToothGrowth, x = "dose", y = "len", color = "supp",
       add = c("mean_se", "dotplot"),
       palette = c("#00AFBB", "#E7B800"))
# Box plot with two factor variables
boxplot(len ~ supp * dose, data=ToothGrowth, frame = FALSE, 
        col = c("#00AFBB", "#E7B800"), ylab="Tooth Length")
# Two-way interaction plot
interaction.plot(x.factor = ToothGrowth$dose, trace.factor = ToothGrowth$supp, 
                 response = ToothGrowth$len, fun = mean, #x.factor: the factor to be plotted on x axis.
                 type = "b", legend = TRUE,               #trace.factor: the factor to be plotted as lines
                 xlab = "Dose", ylab="Tooth Length",      #response: a numeric variable giving the response
                 pch=c(1,19), col = c("#00AFBB", "#E7B800"))  #type: the type of plot. Allowed values include p (for point only), l (for line only) and b (for both point and line).
#----------------------------------------------------------------------------------------
#Compute two-way ANOVA test
#The R function aov() can be used to answer this question. The function summary.aov() is used to summarize the analysis of variance model
res.aov2 <- aov(len ~ supp + dose, data = ToothGrowth)
summary(res.aov2)
#we can conclude that both supp and dose are statistically significant.
#dose is the most significant factor variable
#These results would lead us to believe that changing delivery methods (supp) or the dose of vitamin C, will impact significantly the mean tooth length.
#---------------
# Two-way ANOVA with interaction effect
# These two calls are equivalent
res.aov3 <- aov(len ~ supp * dose, data = ToothGrowth)
res.aov3 <- aov(len ~ supp + dose + supp:dose, data = ToothGrowth)
summary(res.aov3)
#It can be seen that the two main effects (supp and dose) are statistically significant, as well as their interaction.
#Note that, in the situation where the interaction is not significant you should use the additive model.
#-------------
#Interpret the results
#the p-value of supp is 0.000429 (significant), which indicates that the levels of supp are associated with significant different tooth length.
#the p-value of dose is < 2e-16 (significant), which indicates that the levels of dose are associated with significant different tooth length.
#the p-value for the interaction between supp*dose is 0.02 (significant), which indicates that the relationships between dose and tooth length depends on the supp method.
#------------------------------
#Compute some summary statistics
require("dplyr")
group_by(ToothGrowth, supp, dose) %>%
  summarise(
    count = n(),
    mean = mean(len, na.rm = TRUE),
    sd = sd(len, na.rm = TRUE)
  )
model.tables(res.aov3, type="means", se = TRUE)   #or
#----------------------------------------------------------------------------------
#Multiple pairwise-comparison between the means of groups
#=================================================
#In ANOVA test, a significant p-value indicates that some of the group means are different, but we don't know which pairs of groups are different.
#It's possible to perform multiple pairwise-comparison, to determine if the mean difference between specific pairs of group are statistically significant.
#----------------------------------------------
#Tukey multiple pairwise-comparisons
#We don't need to perform the test for the "supp" variable because it has only two levels, which have been already proven to be significantly different by ANOVA test. Therefore, the Tukey HSD test will be done only for the factor variable "dose"
TukeyHSD(res.aov3, which = "dose")
#It can be seen from the output, that all pairwise comparisons are significant with an adjusted p-value < 0.05
#----------------------------------
#Multiple comparisons using multcomp package
install.packages("multcomp")
library(multcomp)
summary(glht(res.aov2, linfct = mcp(dose = "Tukey")))
#glht(model, lincft)
#model: a fitted model, for example an object returned by aov().
#lincft(): a specification of the linear hypotheses to be tested. Multiple comparisons in ANOVA models are specified by objects returned from the function mcp().
#------------------------------------
#Pairwise t-test
#The function pairwise.t.test() can be also used to calculate pairwise comparisons between group levels with corrections for multiple testing.
pairwise.t.test(ToothGrowth$len, ToothGrowth$dose,
                p.adjust.method = "BH")
#=======================================================
#Check ANOVA assumptions: test validity?
#ANOVA assumes that the data are normally distributed and the variance across groups are homogeneous. We can check that with some diagnostic plots.
#------------------------
#Check the homogeneity of variance assumption
#The residuals versus fits plot is used to check the homogeneity of variances.
#In the plot below, there is no evident relationships between residuals and fitted values (the mean of each groups), which is good. So, we can assume the homogeneity of variances.
# 1. Homogeneity of variances
plot(res.aov3, 1)
#Points 32 and 23 are detected as outliers, which can severely affect normality and homogeneity of variance. It can be useful to remove outliers to meet the test assumptions.
#Use the Levene's test to check the homogeneity of variances
library(car)
leveneTest(len ~ supp*dose, data = ToothGrowth)
#From the output above we can see that the p-value is not less than the significance level of 0.05.
#Therefore, we can assume the homogeneity of variances in the different treatment groups.
#-------------------------
#Check the normality assumpttion
#Normality plot of the residuals. In the plot below, the quantiles of the residuals are plotted against the quantiles of the normal distribution.
# 2. Normality
plot(res.aov3, 2)
#As all the points fall approximately along this reference line, we can assume normality.
#The conclusion above, is supported by the Shapiro-Wilk test on the ANOVA residuals (W = 0.98, p = 0.5) which finds no indication that normality is violated.
# Extract the residuals
aov_residuals <- residuals(object = res.aov3)
# Run Shapiro-Wilk test
shapiro.test(x = aov_residuals )
#=========================================================================================
#Compute two-way ANOVA test in R for unbalanced designs
#An unbalanced design has unequal numbers of subjects in each group.
#There are three fundamentally different ways to run an ANOVA in an unbalanced design. They are known as Type-I, Type-II and Type-III sums of squares.
#To keep things simple, note that The recommended method are the Type-III sums of squares.
#The three methods give the same result when the design is balanced. However, when the design is unbalanced, they don't give the same results.
install.packages("car")
library(car)
my_anova <- aov(len ~ supp * dose, data = ToothGrowth)
Anova(my_anova, type = "III")
