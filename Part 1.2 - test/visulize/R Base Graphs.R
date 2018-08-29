#R Base Graphs
#------------------------------
plot(x, y, type = "l", lty = 1)
lines(x, y, type = "l", lty = 1)
#x, y: coordinate vectors of points to join
#type: character indicating the type of plotting. Allowed values are:
#   "p" for points
#   "l" for lines
#   "b" for both points and lines
#    "c" for empty points joined by lines
#    "o" for overplotted points and lines
#   "s" and "S" for stair steps
#   "n" does not produce any points or lines
#lty: line types. Line types can either be specified as an integer (0=blank, 1=solid (default), 2=dashed, 3=dotted, 4=dotdash, 5=longdash, 6=twodash) or as one of the character strings "blank", "solid", "dashed", "dotted", "dotdash", "longdash", or "twodash", where "blank" uses 'invisible lines' (i.e., does not draw them).
# Create some variables
x <- 1:10
y1 <- x*x
y2  <- 2*y1
#We'll plot a plot with two lines: lines(x, y1) and lines(x, y2).
#Note ::that the function lines() can not produce a plot on its own. However, it can be used to add lines() on an existing graph. This means that, first you have to use the function plot() to create an empty graph and then use the function lines() to add lines.
#-------------------
#Basic line plots
# Create a basic stair steps plot 
plot(x, y1, type = "S")
# Show both points and line
plot(x, y1, type = "b", pch = 19, 
     col = "red", xlab = "x", ylab = "y")
#Plots with multiple lines
# Create a first line
plot(x, y1, type = "b", frame = FALSE, pch = 19, 
     col = "red", xlab = "x", ylab = "y")
# Add a second line
lines(x, y2, pch = 18, col = "blue", type = "b", lty = 2)
# Add a legend to the plot
legend("topleft", legend=c("Line 1", "Line 2"),
       col=c("red", "blue"), lty = 1:2, cex=0.8)
#-------------------------------------------
#scatter plots
data(mtcars)
summary(mtcars)
x <- mtcars$wt
y <- mtcars$mpg
# Plot with main and axis titles
# Change point shape (pch = 19) and remove frame.
plot(x, y, main = "Main title",
     xlab = "X axis title", ylab = "Y axis title",
     pch = 19, frame = FALSE)
# Add regression line
plot(x, y, main = "Main title",
     xlab = "X axis title", ylab = "Y axis title",
     pch = 19, frame = FALSE)
abline(lm(y ~ x, data = mtcars), col = "blue")
# Add loess fit
plot(x, y, main = "Main title",
     xlab = "X axis title", ylab = "Y axis title",
     pch = 19, frame = FALSE)
lines(lowess(x, y), col = "blue")
#-------Enhanced scatter plots: car::scatterplot()
#The function scatterplot() [in car package] makes enhanced scatter plots, with box plots in the margins, a non-parametric regression smooth, smoothed conditional spread, outlier identification, and a regression line, .
install.packages("car")
library("car")
data(cars)
scatterplot(wt ~ mpg, data = mtcars)
#plot contain
#        the points
 #       the regression line (in green)
  #      the smoothed conditional spread (in red dashed line)
   #     the non-parametric regression smooth (solid line, red)
# Suppress the smoother and frame
scatterplot(wt ~ mpg, data = mtcars, 
            smoother = FALSE, grid = FALSE, frame = FALSE)
# Scatter plot by groups ("cyl")
scatterplot(wt ~ mpg | cyl, data = mtcars,smoother = FALSE, grid = FALSE, frame = FALSE)
#labels: a vector of point labels
#id.n, id.cex, id.col: Arguments for labeling points specifying the number, the size and the color of points to be labelled.
# Add labels
scatterplot(wt ~ mpg, data = mtcars,
            smoother = FALSE, grid = FALSE, frame = FALSE,
            labels = rownames(mtcars), id.n = nrow(mtcars),
            id.cex = 0.7, id.col = "steelblue",
            ellipse = TRUE)
#note::log to produce log axes. Allowed values are log = "x", log = "y" or log = "xy"
#      boxplots: Allowed values are:
 #       "x": a box plot for x is drawn below the plot
  #    "y": a box plot for y is drawn to the left of the plot
   #   "xy": both box plots are drawn
    #  "" or FALSE to suppress both box plots.
     # ellipse: if TRUE data-concentration ellipses are plotted.
#--------------3D scatter plots
head(iris)
# Prepare the data set
x <- iris$Sepal.Length
y <- iris$Sepal.Width
z <- iris$Petal.Length
grps <- as.factor(iris$Species)
# Plot
install.packages("scatterplot3d")
library(scatterplot3d)
scatterplot3d(x, y, z, pch = 16)
# Change color by groups
# add grids and remove the box around the plot
# Change axis labels: xlab, ylab and zlab
colors <- c("#999999", "#E69F00", "#56B4E9")
scatterplot3d(x, y, z, pch = 16, color = colors[grps],
              grid = TRUE, box = FALSE, xlab = "Sepal length", 
              ylab = "Sepal width", zlab = "Petal length")





