#run test
#runs.test(x, exact = FALSE, alternative = c("two.sided", "less", "greater"))
queue <- factor(c("f", "m", "m", "f", "m", "f", "f", "f"))
library(tseries)
runs.test(queue, alternative="two.sided")
