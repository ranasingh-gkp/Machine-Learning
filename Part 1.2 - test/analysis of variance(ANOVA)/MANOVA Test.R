#MANOVA Test
#-------------------------------------
#there multiple response variables you can test them simultaneously using a multivariate analysis of variance (MANOVA)
#--------------
#Assumptions of MANOVA
#The dependent variables should be normally distribute within groups.
#Homogeneity of variances across the range of predictors.
#Linearity between all pairs of dependent variables, all pairs of covariates, and all dependent variable-covariate pairs in each cell
#-----------------
# Store the data in the variable my_data
my_data <- iris
install.packages("dplyr")
# Show a random sample
set.seed(1234)
dplyr::sample_n(my_data, 10)
#We want to know if there is any significant difference, in sepal and petal length, between the different species.
#Compute MANOVA test
sepl <- iris$Sepal.Length
petl <- iris$Petal.Length
# MANOVA test
res.man <- manova(cbind(Sepal.Length, Petal.Length) ~ Species, data = iris)
summary(res.man)
# Look to see which differ
summary.aov(res.man)
#it can be seen that the two variables are highly significantly different among Species.