#feature selection using Boruta
#One of the best ways for implementing feature selection with wrapper methods is to use Boruta package that finds the importance of a feature by creating shadow features.

#It works in the following steps:
#1) Firstly, it adds randomness to the given data set by creating shuffled copies of all features (which are called shadow features).
#2)Then, it trains a random forest classifier on the extended data set and applies a feature importance measure (the default is Mean Decrease Accuracy) to evaluate the importance of each feature where higher means more important.
#3)At every iteration, it checks whether a real feature has a higher importance than the best of its shadow features (i.e. whether the feature has a higher Z-score than the maximum Z-score of its shadow features) and constantly removes features which are deemed highly unimportant.
#4)Finally, the algorithm stops either when all features get confirmed or rejected or it reaches a specified limit of random forest runs.

#---------------------
install.packages("Boruta")
library(Boruta)
traindata <- read.csv("train.csv", header = T, stringsAsFactors = F)
#Checking the structure of processed train file
str(train_processed)
names(traindata) <- gsub("_", "", names(traindata))#gsub() function is used to replace an expression with other one. In this case, I've replaced the underscore(_) with blank("")
summary(traindata)
#We find that many variables have missing values. It's important to treat missing values prior to implementing boruta package. Moreover, this data set also has blank values. Let's clean this data set.
traindata[traindata == ""] <- NA   # we'll replace blank cells with NA. This will help me treat all NA's at once
traindata <- traindata[complete.cases(traindata),]#simplest method of missing value treatment i.e. list wise deletion.
#Let's convert the categorical variables into factor data type
convert <- c(2:6, 11:13)
traindata[,convert] <- data.frame(apply(traindata[convert], 2, as.factor))
#----Now is the time to implement and check the performance of boruta package. The syntax of boruta is almost similar to regression (lm) method
set.seed(123)
boruta.train <- Boruta(LoanStatus~.-LoanID, data = traindata, doTrace = 2)
print(boruta.train)
#====visulization
#Now, we'll plot the boruta variable importance chart.
plot(boruta.train, xlab = "", xaxt = "n")
#plot function in Boruta adds the attribute values to the x-axis horizontally where all the attribute values are not dispayed due to lack of space.
lz<-lapply(1:ncol(boruta.train$ImpHistory),function(i)
  boruta.train$ImpHistory[is.finite(boruta.train$ImpHistory[,i]),i])
names(lz) <- colnames(boruta.train$ImpHistory)
Labels <- sort(sapply(lz,median))
axis(side = 1,las=2,labels = names(Labels),
       at = 1:ncol(boruta.train$ImpHistory), cex.axis = 0.7)
#Blue boxplots correspond to minimal, average and maximum Z score of a shadow attribute. Red, yellow and green boxplots represent Z scores of rejected, tentative and confirmed attributes respectively.
#Now is the time to take decision on tentative attributes.  The tentative attributes will be classified as confirmed or rejected by comparing the median Z score of the attributes with the median Z score of the best shadow attribute. 
final.boruta <- TentativeRoughFix(boruta.train)
print(final.boruta)
getSelectedAttributes(final.boruta, withTentative = F)#Let's obtain the list of confirmed attributes
#We'll create a data frame of the final result derived from Boruta.
boruta.df <- attStats(final.boruta)
class(boruta.df)
print(boruta.df)

#============================
#recursive feature elimination (RFE)
library(caret)
library(randomForest)
set.seed(123)
control <- rfeControl(functions=rfFuncs, method="cv", number=10)
rfe.train <- rfe(traindata[,2:12], traindata[,13], sizes=1:12, rfeControl=control)# implement the RFE algorithm n
#We can also check the outcome of this algorithm.
rfe.train
#visulization
plot(rfe.train, type=c("g", "o"), cex = 1.0, col = 1:11)
#we see that recursive feature elimination algorithm has selected "CreditHistory" as the only important feature among the 11 features in the dataset.
