#multicollinarity
colnames(X50_Startups)=c("R.D SPEND","ADMIN","MARKET.SPEND","STATE","PROFIT")
X50_Startups$STATE= as.factor(X50_Startups$STATE)
MODEL=lm(PROFIT~.,data=X50_Startups)
summary(MODEL)
cor(MODEL[,1:3])
vif(MODEL)# NON OF VALUE GREATER THEN 10, SO MULTICOLLINARITY IS NOT THE PROBLEM
summary(MODEL)$r.squared
