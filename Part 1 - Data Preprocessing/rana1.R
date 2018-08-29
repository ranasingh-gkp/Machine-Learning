install.packages("readxl")
library(readxl)
datasets <- read.csv("Data.csv")
View(Data)
dataset = read.csv("Data.csv")
# missing value
datasets$Age = ifelse(is.na(datasets$Age),ave(datasets$Age, FUN = function(x) mean(x, na.rm = TRUE)), datasets$Age)  #ifelse(is.na(dataset$Age) will show value in dataset is missing or not...if true then accept next line otherwise third line
datasets$Salary = ifelse(is.na(datasets$Salary),ave(datasets$Salary, FUN = function(x) mean(x, na.rm = TRUE)), datasets$Salary)
setwd("E:/data analytics/Machine Learning A-Z/Part 1 - Data Preprocessing")
# categorical varaiable
datasets$Country=factor(datasets$Country,
                        levels = c('France','Spain','Germany'),
                        labels = c(1,2,3))
datasets$Purchased=factor(datasets$Purchased,
                        levels = c('No','Yes'),
                        labels = c(0,1))
#Splitting the Dataset into the Training set and Test set
install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(datasets$Purchased, SplitRatio = 0.8)
training_set = subset(datasets, split == TRUE)
test_set = subset(datasets, split == FALSE)
#feature scale scaling
#machine learning depend upon eucleian distance so there must bbe scaling between different variabel(age,,salary)
#here we will scale non-categorical variable
training_set[,2:3]=scale(training_set[,2:3]) #(standardization, normalization) method
test_set[,2:3]=scale(test_set[,2:3]) 
#scaling dummy variiable depend , what type  of data we have, we can scale dummy variable in order to increase accuracy but they can loose there identities.
# scaling will be in between -1 to +1.
#some time we use scaling in decision tree also although it's not based upon eucleian distance
#dependent variable if is in categorical variable then , no need to apply scaling but if not then we can apply
