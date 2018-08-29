# Apriori
#association rules model here used
#------------------------------
# Data Preprocessing
install.packages('arulesViz')
library(arules)
library("arulesViz")  #graphing and plotting the rules

dataset = read.csv('Market_Basket_Optimisation.csv', header = FALSE)
#Apriori do not take  csv file directly, it convert into sparse matrix.
#sparse matrix is matrix contain lot of zero
tr = read.transactions('Market_Basket_Optimisation.csv', sep = ',', rm.duplicates = TRUE)
#in Apriori analysis, it should not have duplicate of items in each basket of customer so rm.duplicates use to remove duplicate
#we will convert many column for each product, put 0 if not in basket,1 if have
#5 transiction contain 1 duplicate
summary(tr)
#result::Based on the summary, we know that one can buy 119 different items in our shop and it contains 7501 different itemsets. The most frequent items bought are eggs, mineral bottles etc.
#-----------Visualise Transactions
#We can also visualise the items being bought using a histogram. This is where the library arulesViz is useful.
itemFrequencyPlot(tr, topN=20, type="absolute")
#----------Apriori Rules
#Based on the transactions, we now create the association rules (based on the Apriori algorithm)
#Here we are only interested in rules with a support of at least 0.001 and a confidence of at least 0.8.
rules <- apriori(tr, parameter = list(supp = 0.001, conf = 0.8))
#We can see that 74 association rules have been deduced from the 7501 transactions.
#Sorting the rules with decreasing confidence
rules <- sort(rules, by="confidence", decreasing=TRUE)
#-------------Inspect rules
inspect(rules)
#You notice that all rules have a confidence of at least 0.8 as specified when creating the association rules. Confidence indicates the probability of the RHS happening given that LHS has happened.

#===========Web Service Input and Output in Azure Machine Learning
# Thinking one step further, eventually we want to have a web service that takes the customer's bought items (or items currently in the cart) as input and gives out other recommended items as output.
#------Web Service Input
dataset1 = read.csv('Market_Basket_Optimisation.csv', header = FALSE)
#dataset1 is a 1x2 matrix that we transform into a row-major vector:
dataset1 <- as.vector(t(dataset1))
dataset1
#----------Find rules with given input as LHS (left hand side)
#Given the items our new customer has bought or has currently placed in her/his cart, we now want to give further recommendations.
#Thus, we select all the association rules with the given items (i.e. dataset1) contained in their LHS's:
rulesMatchLHS <- subset(rules)
rulesMatchLHS
inspect(rulesMatchLHS)
#----------Web Service Output
OutputClient =data.frame(  lhs = labels((rulesMatchLHS))$elements,
                           rhs = labels((rulesMatchLHS))$elements,
                           rulesMatchLHS@quality)
