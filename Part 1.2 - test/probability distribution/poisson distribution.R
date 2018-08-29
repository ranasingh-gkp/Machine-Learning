install.packages("visualize")
library(visualize)
ppois(16, lambda=12)   # lower tail
ppois(16, lambda=12, lower=FALSE)   # upper tail 
visualize.pois(stat = 1, lambda = 12, section = "lower",
               strict = FALSE)

# Evaluates lower tail.
visualize.pois(stat = 1, lambda = 12, section = "lower", strict = FALSE) 

# Evaluates bounded region.
visualize.pois(stat = c(1,10), lambda = 12, section = "bounded", strict = c(0,1))

# Evaluates upper tail.
visualize.pois(stat = 1, lambda = 12, section = "upper", strict = 1)

#----------------------------
#using ggplot
plot( dpois( x=0:20, lambda=12 ), type="b")
