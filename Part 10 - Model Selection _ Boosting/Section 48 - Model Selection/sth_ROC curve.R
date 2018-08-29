#ROC curve
#http://www.sthda.com/english/articles/36-classification-methods-essentials/143-evaluation-of-classification-model-accuracy-essentials/
#The ROC curve (or receiver operating characteristics curve ) is a popular graphical measure for assessing the performance or the accuracy of a classifier, which corresponds to the total proportion of correctly classified observations.
#Since we don't usually know the probability cutoff in advance, the ROC curve is typically used to plot the true positive rate (or sensitivity on y-axis) against the false positive rate (or "1-specificity" on x-axis) at all possible probability cutoffs.
# This shows the trade off between the rate at which you can correctly predict something with the rate of incorrectly predicting something. Another visual representation of the ROC plot is to simply display the sensitive against the specificity.
#The Area Under the Curve (AUC) summarizes the overall performance of the classifier, over all possible probability cutoffs. It represents the ability of a classification algorithm to distinguish 1s from 0s (i.e, events from non-events or positives from negatives).
#For a good model, the ROC curve should rise steeply, indicating that the true positive rate (y-axis) increases faster than the false positive rate (x-axis) as the probability threshold decreases.
#So, the "ideal point" is the top left corner of the graph, that is a false positive rate of zero, and a true positive rate of one. This is not very realistic, but it does mean that the larger the AUC the better the classifier.
#The AUC metric varies between 0.50 (random classifier) and 1.00. Values above 0.80 is an indication of a good classifier.

library(tidyverse)
library(caret)
#-----Building a classification model
#To keep things simple, we'll perform a binary classification, where the outcome variable can have only two possible values: negative vs positive.
# Load the data
data("PimaIndiansDiabetes2", package = "mlbench")
pima.data <- na.omit(PimaIndiansDiabetes2)
# Inspect the data
sample_n(pima.data, 3)
# Split the data into training and test set
set.seed(123)
training.samples <- pima.data$diabetes %>%
  createDataPartition(p = 0.8, list = FALSE)
train.data  <- pima.data[training.samples, ]
test.data <- pima.data[-training.samples, ]
library(MASS)
# Fit LDA
fit <- lda(diabetes ~., data = train.data)
# Make predictions on the test data
predictions <- predict(fit, test.data)
prediction.probabilities <- predictions$posterior[,2]
predicted.classes <- predictions$class 
observed.classes <- test.data$diabetes
#-----Computing and plotting ROC curve
install.packages("pROC")
library(pROC)
# Compute roc
res.roc <- roc(observed.classes, prediction.probabilities)
plot.roc(res.roc, print.auc = TRUE)
#The gray diagonal line represents a classifier no better than random chance.
#A highly performant classifier will have an ROC that rises steeply to the top-left corner, that is it will correctly identify lots of positives without misclassifying lots of negatives as positives.
#In our example, the AUC is 0.85, which is close to the maximum ( max = 1). So, our classifier can be considered as very good. A classifier that performs no better than chance is expected to have an AUC of 0.5 when evaluated on an independent test set not used to train the model.
# Extract some interesting results
roc.data <- data_frame(
  thresholds = res.roc$thresholds,
  sensitivity = res.roc$sensitivities,
  specificity = res.roc$specificities
)
# Get the probality threshold for specificity = 0.6
roc.data %>% filter(specificity >= 0.6)
#The best threshold with the highest sum sensitivity + specificity can be printed as follow. There might be more than one threshold.
plot.roc(res.roc, print.auc = TRUE, print.thres = "best")
#result:::Here, the best probability cutoff is 0.335 resulting to a predictive classifier with a specificity of 0.84 and a sensitivity of 0.660.
#Note that, print.thres can be also a numeric vector containing a direct definition of the thresholds to display:
plot.roc(res.roc, print.thres = c(0.3, 0.5, 0.7))
#-------Multiple ROC curves
#If you have grouping variables in your data, you might wish to create multiple ROC curves on the same plot.
# Create some grouping variable
glucose <- ifelse(test.data$glucose < 127.5, "glu.low", "glu.high")
age <- ifelse(test.data$age < 28.5, "young", "old")
roc.data <- roc.data %>%
  filter(thresholds !=-Inf) %>%
  mutate(glucose = glucose, age =  age)
# Create ROC curve
ggplot(roc.data, aes(specificity, sensitivity)) + 
  geom_path(aes(color = age))+
  scale_x_reverse(expand = c(0,0))+
  scale_y_continuous(expand = c(0,0))+
  geom_abline(intercept = 1, slope = 1, linetype = "dashed")+
  theme_bw()
#------------Multiclass settings
#We start by building a linear discriminant model using the iris data set, which contains the length and width of sepals and petals for three iris species.
# We want to predict the species based on the sepal and petal parameters using LDA.
# Load the data
data("iris")
# Split the data into training (80%) and test set (20%)
set.seed(123)
training.samples <- iris$Species %>%
  createDataPartition(p = 0.8, list = FALSE)
train.data <- iris[training.samples, ]
test.data <- iris[-training.samples, ]
# Build the model on the train set
library(MASS)
model <- lda(Species ~., data = train.data)
#Performance metrics (sensitivity, specificity, .) of the predictive model can be calculated, separately for each class, comparing each factor level to the remaining levels (i.e. a "one versus all" approach).
# Make predictions on the test data
predictions <- model %>% predict(test.data)
# Model accuracy
confusionMatrix(predictions$class, test.data$Species)
#Note:: that, the ROC curves are typically used in binary classification but not for multiclass classification problems.
