#ggplot2
#-----------------------
# Installation
install.packages('ggplot2')
# Loading
library(ggplot2)
# Load the data
data(mtcars)
df <- mtcars[, c("mpg", "cyl", "wt")]
head(df)
#=============================================
#qplot
#qplot(x, y=NULL, data, geom="auto", xlim = c(NA, NA), ylim =c(NA, NA))
#x : x values
#y : y values (optional)
#data : data frame to use (optional).
#geom : Character vector specifying geom to use. Defaults to "point" if x and y are specified, and "histogram" if only x is specified.
#xlim, ylim: x and y axis limits
#main: Plot title
#xlab, ylab: x and y axis labels
#log: which variables to log transform. Allowed values are "x", "y" or "xy"
#-------------------Scatter plots--------------------------
# Use data from numeric vectors
x <- 1:10; y = x*x
# Basic plot
qplot(x,y)
# Add line
qplot(x, y, geom=c("point", "line"))
# Use data from a data frame
qplot(mpg, wt, data=mtcars)
#The option smooth is used to add a smoothed line with its standard error:
# Smoothing
qplot(mpg, wt, data = mtcars, geom = c("point", "smooth"))


