x <- c(1,2,2,3,3,3,3,4,5,6)
y <- c(2,3,4,5,5,6,6,6,6,7)
z <- c(12,13,14,15,15,16,16,16,16,17)
# Do x and y come from the same distribution?
ks.test(x, y)

# test if x is stochastically larger than x2
x2 <- rnorm(50, -1)
plot(ecdf(x), xlim = range(c(x, x2)))
plot(ecdf(x2), add = TRUE, lty = "dashed")
t.test(x, x2, alternative = "g")
wilcox.test(x, x2, alternative = "g")
ks.test(x, x2, alternative = "l")




















