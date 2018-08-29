pexp(2, rate=1/3) 

data =  data.frame(x=rexp(n = 100000, rate = 1/3))
m <- ggplot(data, aes(x=data$x))
m + geom_density()

#The exponential distribution can be obtained with the dexp function, so you can plot it by sampling x values and processing them with that function:
  x <- seq(0, 20, length.out=1000)
dat <- data.frame(x=x, px=dexp(x, rate=0.65))
library(ggplot2)
ggplot(dat, aes(x=x, y=px)) + geom_line()
#-------------------------------
curve(dexp, xlim=c(0,10))
#--------------------------------
#And a ggplot solution that takes advantage of stat_function(...), which was intended for this.
library(ggplot2)
df <- data.frame(x=seq(0,10,by=0.1))
ggplot(df) + stat_function(aes(x),fun=dexp)
#-----------------------------------
h<-ggplot(data.frame(x=c(0,7)),aes(x=x))
h<-h+stat_function(fun=dexp,geom = "line",size=2,col="blue",args = (mean=1.5))
h<-h+stat_function(fun=dexp,geom = "line",size=2,col="green",args = (mean=1))
h<-h+stat_function(fun=dexp,geom = "line",size=2,col="red",args = (mean=0.5))

library(ggplot2)
ggplot(data.frame(x=c(0,7)),aes(x=x))+stat_function(fun=dexp,geom =    "line",size=2,col="orange",args = (mean=0.5))
ggplot(data.frame(x=c(0,7)),aes(x=x))+stat_function(fun=dexp,geom =     "line",size=2,col="purple",args = (mean=1))
ggplot(data.frame(x=c(0,7)),aes(x=x))+stat_function(fun=dexp,geom =     "line",size=2,col="blue",args = (mean=1.5))
