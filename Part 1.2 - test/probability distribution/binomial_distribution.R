dbinom(4, size=12, prob=0.2)
#Suppose there are twelve multiple choice questions in an English class quiz. Each question has five possible answers, and only one of them is correct. Find the probability of having four or less correct answers if a student attempts to answer every question at random
dbinom(0, size=12, prob=0.2) + 
  + dbinom(1, size=12, prob=0.2) + 
  + dbinom(2, size=12, prob=0.2) + 
  + dbinom(3, size=12, prob=0.2) + 
  + dbinom(4, size=12, prob=0.2)
#Alternatively, we can use the cumulative probability function for binomial distribution pbinom.
pbinom(4, size=12, prob=0.2)


## visualize.it acts as the general wrapper.
## For guided application of visualize, see the visualize.distr_name list.
# Binomial distribution evaluated at lower tail.
install.packages("visualize")
library(visualize)
visualize.it(dist = 'binom', stat = 2, params = list(size = 12,prob = .2),
             section ="lower", strict = TRUE)
visualize.binom(stat = 2, size = 12, prob =.2, section ="lower", strict = TRUE)


