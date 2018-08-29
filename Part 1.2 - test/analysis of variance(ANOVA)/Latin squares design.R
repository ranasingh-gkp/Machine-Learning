#create a dataframe 
#Treatments are assigned at random within rows and columns, with each treatment once per row and once per column
#There are equal numbers of rows, columns, and treatments.
#Useful where the experimenter desires to control variation in two different directions
fertil <- c(rep("fertil1",1), rep("fertil2",1), rep("fertil3",1), rep("fertil4",1), rep("fertil5",1))
treat <- c(rep("treatA",5), rep("treatB",5), rep("treatC",5), rep("treatD",5), rep("treatE",5))
seed <- c("A","E","C","B","D", "C","B","A","D","E", "B","C","D","E","A", "D","A","E","C","B", "E","D","B","A","C")
freq <- c(42,45,41,56,47, 47,54,46,52,49, 55,52,57,49,45, 51,44,47,50,54, 44,50,48,43,46)
mydata <- data.frame(treat, fertil, seed, freq)
mydata
matrix(mydata$seed, 5,5)
matrix(mydata$freq, 5,5)
# BOX PLOT
par(mfrow=c(2,2))
plot(freq ~ fertil+treat+seed, mydata)
#Note that the differences considering the fertilizer is low; it is medium considering the tillage, and is very high considering the seed.
#ANOVA table
myfit <- lm(freq ~ fertil+treat+seed, mydata)
anova(myfit)
#- The difference between group considering the fertilizer is not significant (p-value > 0.1);
#- The difference between group considering the tillage is quite significant (p-value < 0.05);
#- The difference between group considering the seed is very significant (p-value < 0.001)

#============================================================
#Chemical Yield Example chemical
### Graeco-Latin Square Designs
## Chemical Yield Example
chemical <- data.frame(yield=c(26,16,19,16,13,    18,21,18,11,21,
                               20,12,16,25,13,    15,15,22,14,17,    10,24,17,17,14),
                       time=factor(c("A","B","C","D","E",  "B","C","D","E","A",
                                     "C","D","E","A","B",  "D","E","A","B","C",
                                     "E","A","B","C","D")),
                       catalyst=factor(c("a","b","c","d","e",  "c","d","e","a","b",
                                         "e","a","b","c","d",  "b","c","d","e","a",
                                         "d","e","a","b","c")),
                       batch=gl(5,5), acid=gl(5,1,25))
sapply(chemical,class)
save.image()

summary( chem.lm <- lm(yield ~ ., data=chemical) )
anova(chem.lm)
aov(chem.lm)
( chem.tk <- TukeyHSD(aov(chem.lm), "time") )
windows(width=5, height=5, pointsize=10)
plot(chem.tk, las=1, sub="Chemical Yield Example")
mtext("Tukey's Honest Significant Difference", side=3, line=0,
      col="NavyBlue")
model.tables(aov(chem.lm), "means")
model.tables(aov(chem.lm), "effects", se=T)
replications(yield ~ ., data=chemical)
