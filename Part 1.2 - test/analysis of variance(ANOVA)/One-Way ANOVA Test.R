#one way ANOVA test
#=========================================================================================
#Null hypothesis: the means of the different groups are the same
#Alternative hypothesis: At least one sample mean is not equal to the others.
#{1)The observations are obtained independently and randomly from the population defined by the factor levels
#2)The data of each factor level are normally distributed.
#3)These normal populations have a common variance. (Levene's test can be used to check this.)}
#---------------------------
#How one-way ANOVA test works?
#Assume that we have 3 groups (A, B, C) to compare:
#1)Compute the common variance, which is called variance within samples (S2within) or residual variance.
#2)Compute the variance between sample means as follow:
 # Compute the mean of each group
 #Compute the variance between sample means (S2between)
#3)Produce F-statistic as the ratio of S2between/S2within.
data(PlantGrowth)
PlantGrowth
# Show a random sample
set.seed(1234)
dplyr::sample_n(PlantGrowth, 10)
# Show the levels
levels(PlantGrowth$group)
#Compute summary statistics by groups - count, mean, sd:
library(dplyr)
group_by(PlantGrowth, group) %>%
  summarise(
    count = n(),
    mean = mean(weight, na.rm = TRUE),
    sd = sd(weight, na.rm = TRUE)
  )
#-----------------------------------------
#Visualize your data
install.packages("ggpubr")
# Box plots
# Plot weight by group and color by group
library("ggpubr")
ggboxplot(PlantGrowth, x = "group", y = "weight", 
          color = "group", palette = c("#00AFBB", "#E7B800", "#FC4E07"),
          order = c("ctrl", "trt1", "trt2"),
          ylab = "Weight", xlab = "Treatment")
# Mean plots
# Plot weight by group
# Add error bars: mean_se
# (other values include: mean_sd, mean_ci, median_iqr, ....)
library("ggpubr")
ggline(PlantGrowth, x = "group", y = "weight", 
       add = c("mean_se", "jitter"), 
       order = c("ctrl", "trt1", "trt2"),
       ylab = "Weight", xlab = "Treatment")
# Box plot
boxplot(weight ~ group, data = PlantGrowth,
        xlab = "Treatment", ylab = "Weight",
        frame = FALSE, col = c("#00AFBB", "#E7B800", "#FC4E07"))
# plotmeans
library("gplots")
plotmeans(weight ~ group, data = PlantGrowth, frame = FALSE,
          xlab = "Treatment", ylab = "Weight",
          main="Mean Plot with 95% CI")
#--------------------------------------------
#Compute one-way ANOVA test
#We want to know if there is any significant difference between the average weights of plants in the 3 experimental conditions.
# Compute the analysis of variance
res.aov <- aov(weight ~ group, data = PlantGrowth)
# Summary of the analysis
summary(res.aov)
#As the p-value is less than the significance level 0.05, we can conclude that there are significant differences between the groups highlighted with "*" in the model summary.
#-------------------------------------------
#Multiple pairwise-comparison between the means of groups
#In one-way ANOVA test, a significant p-value indicates that some of the group means are different, but we don't know which pairs of groups are different.
#It's possible to perform multiple pairwise-comparison, to determine if the mean difference between specific pairs of group are statistically significant.
#----------
#Tukey multiple pairwise-comparisons
TukeyHSD(res.aov)
#diff: difference between means of the two groups
#lwr, upr: the lower and the upper end point of the confidence interval at 95% (default)
#p adj: p-value after adjustment for the multiple comparisons.
#inference::It can be seen from the output, that only the difference between trt2 and trt1 is significant with an adjusted p-value of 0.012
#----------------------------------------------
#Multiple comparisons using multcomp package
#glht(model, lincft) #glht stands for general linear hypothesis tests.
#model: a fitted model, for example an object returned by aov().
#lincft(): a specification of the linear hypotheses to be tested. Multiple comparisons in ANOVA models are specified by objects returned from the function mcp().
library(multcomp)
summary(glht(res.aov, linfct = mcp(group = "Tukey")))
#------------------------------
#Pairewise t-test
#The function pairewise.t.test() can be also used to calculate pairwise comparisons between group levels with corrections for multiple testing.
pairwise.t.test(PlantGrowth$weight, PlantGrowth$group,
                p.adjust.method = "BH")
#the p-values have been adjusted by the Benjamini-Hochberg method.
#-----------------------------
#Check ANOVA assumptions: test validity
#===============================
#Check the homogeneity of variance assumption
#The residuals versus fits plot can be used to check the homogeneity of variances
# 1. Homogeneity of variances
plot(res.aov, 1)
#In the plot below, there is no evident relationships between residuals and fitted values (the mean of each groups), which is good. So, we can assume the homogeneity of variances.
#Points 17, 15, 4 are detected as outliers, which can severely affect normality and homogeneity of variance. It can be useful to remove outliers to meet the test assumptions.
#---------
#It's also possible to use Bartlett's test or Levene's test to check the homogeneity of variances.
#We recommend Levene's test, which is less sensitive to departures from normal distribution. The function leveneTest() [in car package] will be used:
library(car)
leveneTest(weight ~ group, data = PlantGrowth)
#inference::From the output above we can see that the p-value is not less than the significance level of 0.05. This means that there is no evidence to suggest that the variance across groups is statistically significantly different. Therefore, we can assume the homogeneity of variances in the different treatment groups.
#----------------------------------------
#How do we save our ANOVA test, in a situation where the homogeneity of variance assumption is violated?
#An alternative procedure (i.e.: Welch one-way test), that does not require that assumption have been implemented in the function oneway.test().
oneway.test(weight ~ group, data = PlantGrowth)
#Pairwise t-tests with no assumption of equal variances
pairwise.t.test(PlantGrowth$weight, PlantGrowth$group,
                p.adjust.method = "BH", pool.sd = FALSE)
#-----------------------------------
#Check the normality assumption
#The normal probability plot of residuals is used to check the assumption that the residuals are normally distributed. It should approximately follow a straight line.
# 2. Normality
plot(res.aov, 2)
#As all the points fall approximately along this reference line, we can assume normality.
#The conclusion above, is supported by the Shapiro-Wilk test on the ANOVA residuals (W = 0.96, p = 0.6) which finds no indication that normality is violated.
# Extract the residuals
aov_residuals <- residuals(object = res.aov )
# Run Shapiro-Wilk test
shapiro.test(x = aov_residuals )
#-----------------------------------------
# a non-parametric alternative to one-way ANOVA is Kruskal-Wallis rank sum test, which can be used when ANNOVA assumptions are not met.
kruskal.test(weight ~ group, data = PlantGrowth)
