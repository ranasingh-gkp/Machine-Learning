# Loan Prediction problem-III 
# it provides several features which makes it a one stop solution for all the modeling needs for supervised machine learning problems.


install.packages("caret", dependencies = c("Depends", "Suggests"))
#Loading caret package
library("caret")

#Loading training data
train<-read.csv("train_u6lujuX_CVtuZ9i.csv",stringsAsFactors = T)

#Looking at the structure of caret package.
str(train)
#=================== Pre-processing using Caret
#Let's check if the data has any missing values:
sum(is.na(train))
#let us use Caret to impute these missing values using KNN algorithm. 
#We will predict these missing values based on other attributes for that row
#we'll scale and center the numerical data by using the convenient preprocess() in Caret.

#-----Imputing missing values using KNN.Also centering and scaling numerical columns
preProcValues <- preProcess(train, method = c("knnImpute","center","scale"))
library('RANN')
train_processed <- predict(preProcValues, train)
sum(is.na(train_processed))

#It is also very easy to use one hot encoding in Caret to create dummy variables for each level of a categorical variable. 
#But first, we'll convert the dependent variable to numerical.
#----Converting outcome variable to numeric
train_processed$Loan_Status<-ifelse(train_processed$Loan_Status=='N',0,1)

id<-train_processed$Loan_ID
train_processed$Loan_ID<-NULL   #removing NULL column

#Checking the structure of processed train file
str(train_processed)

#----Now, creating dummy variables using one hot encoding:
#Converting every categorical variable to numerical using dummy variables
dmy <- dummyVars(" ~ .", data = train_processed,fullRank = T)#Here, "fullrank=T" will create only (n-1) columns for a categorical column with n different levels. This works well particularly for the representing categorical predictors like gender, married, etc. where we only have two levels: Male/Female, Yes/No,
train_transformed <- data.frame(predict(dmy, newdata = train_processed))

#Checking the structure of transformed train file
str(train_transformed)
#------Converting the dependent variable back to categorical
train_transformed$Loan_Status<-as.factor(train_transformed$Loan_Status)
#============Splitting data using caret
#We'll be creating a cross-validation set from the training set to evaluate our model against.
#It is important to rely more on the cross-validation set for the actual evaluation of your model otherwise you might end up overfitting the public leaderboard.

#We'll use createDataPartition() to split our training data into two sets : 75% and 25%. Since, our outcome variable is categorical in nature, this function will make sure that the distribution of outcome variable classes will be similar in both the sets.
#Spliting training set into two parts based on outcome: 75% and 25%
index <- createDataPartition(train_transformed$Loan_Status, p=0.75, list=FALSE)
trainSet <- train_transformed[ index,]
testSet <- train_transformed[-index,]

#Checking the structure of trainSet
str(trainSet)
#==============Feature selection using Caret
#we'll be using Recursive Feature elimination which is a wrapper method to find the best subset of features to use for modeling.
#Feature selection using rfe in caret
control <- rfeControl(functions = rfFuncs,
                      method = "repeatedcv",         #The external resampling method: boot, cv, LOOCV or LGOCV (for repeated training/test splits
                      repeats = 3,                   #For repeated k-fold cross-validation only: the number of complete sets of folds to compute
                      verbose = FALSE)               #a logical to print a log for each external resampling iteration
outcomeName<-'Loan_Status'
predictors<-names(trainSet)[!names(trainSet) %in% outcomeName]
Loan_Pred_Profile <- rfe(trainSet[,predictors], trainSet[,outcomeName],
                         rfeControl = control)
Loan_Pred_Profile
#Taking only the top 5 predictors       #see the above result
predictors<-c("Credit_History", "LoanAmount", "Loan_Amount_Term", "ApplicantIncome", "CoapplicantIncome")

#==========Training models using Caret
#This is probably the part where Caret stands out from any other available package. It provides the ability for implementing 200+ machine learning algorithms using consistent syntax. To get a list of all the algorithms that Caret supports, you can use:
names(getModelInfo())
#We can simply apply a large number of algorithms with similar syntax. For example, to apply, GBM, Random forest, Neural net and Logistic regression :
model_gbm<-train(trainSet[,predictors],trainSet[,outcomeName],method='gbm')
model_rf<-train(trainSet[,predictors],trainSet[,outcomeName],method='rf')
model_nnet<-train(trainSet[,predictors],trainSet[,outcomeName],method='nnet')
model_glm<-train(trainSet[,predictors],trainSet[,outcomeName],method='glm')
summary(model_glm)
#You can proceed further tune the parameters in all these algorithms using the parameter tuning techniques.

#=============Parameter tuning using Caret
#It is possible to customize almost every step in the tuning process. 
#The resampling technique used for evaluating the performance of the model using a set of parameters in Caret by default is bootstrap, but it provides alternatives for using k-fold, repeated k-fold as well as Leave-one-out cross validation (LOOCV) which can be specified using trainControl(). In this example, we'll be using 5-Fold cross-validation repeated 5 times.
fitControl <- trainControl(
  method = "repeatedcv",
  number = 5,
  repeats = 5)
#If the search space for parameters is not defined, Caret will use 3 random values of each tunable parameter and use the cross-validation results to find the best set of parameters for that algorithm. Otherwise, there are two more ways to tune parameters:
#----Using tuneGrid
modelLookup(model='gbm')
#using grid search
#Creating grid
grid <- expand.grid(n.trees=c(10,20,50,100,500,1000),shrinkage=c(0.01,0.05,0.1,0.5),n.minobsinnode = c(3,5,10),interaction.depth=c(1,5,10))
# training the model
model_gbm<-train(trainSet[,predictors],trainSet[,outcomeName],method='gbm',trControl=fitControl,tuneGrid=grid)
# summarizing the model
print(model_gbm)
#Accuracy was used to select the optimal model using  the largest value.
#RESULT::The final values used for the model were n.trees = 10, interaction.depth = 1, shrinkage = 0.05 and n.minobsinnode = 3
plot(model_gbm)
#Thus, for all the parameter combinations that you listed in expand.grid(), a model will be created and tested using cross-validation.
# The set of parameters with the best cross-validation performance will be used to create the final model which you get at the end.
#---------Using tuneLength
#Instead, of specifying the exact values for each parameter for tuning we can simply ask it to use any number of possible values for each tuning parameter through tuneLength. Let's try an example using tuneLength=10.
#using tune length
model_gbm<-train(trainSet[,predictors],trainSet[,outcomeName],method='gbm',trControl=fitControl,tuneLength=10)
print(model_gbm)
#Tuning parameter 'shrinkage' was held constant at a value of 0.1
#Tuning parameter 'n.minobsinnode' was held constant at a value of 10
#Accuracy was used to select the optimal model using  the largest value.
#The final values used for the model were n.trees = 50, interaction.depth = 2, shrinkage = 0.1 and n.minobsinnode = 10.
plot(model_gbm)
#Here, it keeps the shrinkage and n.minobsinnode parameters constant while alters n.trees and interaction.depth over 10 values and uses the best combination to train the final model with.

#============Variable importance estimation using caret
#Caret also makes the variable importance estimates accessible with the use of varImp() for any model.
#Clearly, the variable importance estimates of different models differs and thus might be used to get a more holistic view of importance of each predictor
# Two main uses of variable importance from various models are::
#Predictors that are important for the majority of models represents genuinely important predictors.
# we should use predictions from models that have significantly different variable importance as their predictions are also expected to be different

#-------Checking variable importance for GBM
#Variable Importance
varImp(object=model_gbm)
#Plotting Varianle importance for GBM
plot(varImp(object=model_gbm),main="GBM - Variable Importance")
#--------Checking variable importance for RF
varImp(object=model_rf)
#Plotting Varianle importance for Random Forest
plot(varImp(object=model_rf),main="RF - Variable Importance")
#--------Checking variable importance for NNET
varImp(object=model_nnet)
#Plotting Variable importance for Neural Network
plot(varImp(object=model_nnet),main="NNET - Variable Importance")       
#--------Checking variable importance for GLM
varImp(object=model_glm)
#Plotting Variable importance for GLM
plot(varImp(object=model_glm),main="GLM - Variable Importance")
#=============Predictions using Caret
#For predicting the dependent variable for the testing set, Caret offers predict.train(). You need to specify the model name, testing data.
#For classification problems, Caret also offers another feature named type which can be set to either "prob" or "raw".
#For type="raw", the predictions will just be the outcome classes for the testing data while for type="prob", it will give probabilities for the occurrence of each observation in various classes of the outcome variable.
#-----Let's take a look at the predictions from our GBM model:
#Predictions
predictions<-predict.train(object=model_gbm,testSet[,predictors],type="raw")
table(predictions)
#Caret also provides a confusionMatrix function 
confusionMatrix(predictions,testSet[,outcomeName])
