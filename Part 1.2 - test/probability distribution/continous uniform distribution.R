runif(10, min=1, max=3)
install.packages("ggplot2")
library(ggplot2)
ggplot(data.frame(x=c(-10,10)), aes(x)) + stat_function(fun=dnorm, args=list(0, 1))
