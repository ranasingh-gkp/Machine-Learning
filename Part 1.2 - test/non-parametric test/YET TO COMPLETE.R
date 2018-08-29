install.packages("randtests")
library(randtests)
x <- rnorm(100)
runs.test(z)
y <- c(13, 17 ,14, 20 ,18, 17 ,16 ,14, 19 ,21 ,18, 20 ,17, 13, 14, 19, 20, 15 ,19 ,17)
z <- c(0.464, 0.137 ,2.455 ,-0.323 ,-0.068,  0.907, -0.513,-0.525 ,0.595 ,0.886 ,-0.482, 1.678, -0.057, -1.229 ,-0.486, -1.787, -0.261 ,1.237 ,1.046 ,0.962)

x1 <- c(2.1, 1.9, 3.2, 2.8, 1.0, 5.1, 4.2, 3.6, 3.9, 2.7)
ks.test(x1,"rnorm" ,mean = 3, sd = 1)

install.packages("signmedian.test")
library(signmedian.test)
x <- c(7.8, 6.6, 6.5, 7.4, 7.3, 7., 6.4, 7.1, 6.7, 7.6, 6.8)
SIGN.test(x, md = 6.5)

sign.test<-function(x=0,y=NULL,alternative="two.sided"){
  n<-sum((x-y)!=0)
  T<-sum(x<y)
  if (alternative=="less") {
    p.value<-pbinom(T,n,0.5)}
  if (alternative=="greater"){
    p.value<- 1-pbinom(T-1,n,0.5)}
  if (alternative=="two.sided"){
    p.value<-2*min(1-pbinom(T-1,n,0.5),pbinom(T,n,0.5))}
  list(n=n,alternative=alternative,T=T,p.value=p.value)}
scores.with.food <- c(74,71,82,77,72,81)

scores.without.food <- c(68,71,86,70,67,80)
sign.test(x=scores.with.food, y=scores.without.food, alternative="less")

