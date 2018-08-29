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
dataset = read.transactions('Market_Basket_Optimisation.csv', sep = ',', rm.duplicates = TRUE)
#in Apriori analysis, it should not have duplicate of items in each basket of customer so rm.duplicates use to remove duplicate
#we will convert many column for each product, put 0 if not in basket,1 if have
#5 transiction contain 1 duplicate
summary(dataset)
itemFrequencyPlot(dataset, topN = 10)#TopN is top 10 product purchased by customers

# Training Apriori on the dataset
rules = apriori(data = dataset, parameter = list(support = 0.0028, confidence = 0.2))#convert confidence from .8 to .4 to .2(divided by 2 each times)
#support here is that the items contain in basket must have minimum support of 0.0028 
# all rules must be taken higher confidence then minimum confidence 0.2
#support is items purchased 3 to 4 in a day multiply by no of week for this problem and overall divided by total transiction of weeks.
#(3*7 per week)/7500
# confidence is by assumption but we dont need very high confident but not very small
#start confidence with default value (0.8) then decrease one by one by analyzing result
#the most important factor is rules 
#each rules must be currect for 80% of transiction
#----------------# Visualising the results
#inspection
inspect(head(sort(rules, by="lift"),3));

plot(rules);

head(quality(rules));

plot(rules, measure=c("support","lift"), shading="confidence");

plot(rules, shading="order", control=list(main ="Two-key plot"));
sel = plot(rules, measure=c("support","lift"), shading="confidence", interactive=TRUE);

subrules = rules[quality(rules)$confidence > 0.4];#trim down the rules to the ones that are more important

subrules
#------------------------------
#This code will produce many different ways to look at the graphs and can even produce 3-D graphs
plot(subrules, method="matrix", measure="lift");

plot(subrules, method="matrix", measure="lift", control=list(reorder=TRUE));

plot(subrules, method="matrix3D", measure="lift");

plot(subrules, method="matrix3D", measure="lift", control = list(reorder=TRUE));

plot(subrules, method="matrix", measure=c("lift", "confidence"));

plot(subrules, method="matrix", measure=c("lift","confidence"), control = list(reorder=TRUE));

plot(rules, method="grouped");

plot(rules, method="grouped", control=list(k=50));

sel = plot(rules, method="grouped", interactive=TRUE);
#----------------------------------------------------
#We can then subset the rules to the top 30 most important rules and then inspect the smaller set of rules individually to determine where there are meaningful associations.
subrules2 = head(sort(rules, by="lift"), 30);

plot(subrules2, method="graph");

plot(subrules2, method="graph", control=list(type="items"));

plot(subrules2, method="paracoord");

plot(subrules2, method="paracoord", control=list(reorder=TRUE));

oneRule = sample(rules, 1);

inspect(oneRule);
#-------------------------------------------------
#Here we can look at the frequent itemsets and we can use the eclat algorithm rather than the apriori algorithm
itemFrequencyPlot(dataset, support = 0.1, cex.names=0.8);

fsets = eclat(dataset, parameter = list(support = 0.05), control = list(verbose=FALSE));

singleItems = fsets[size(items(fsets)) == 1];

singleSupport = quality(singleItems)$support;

names(singleSupport) = unlist(LIST(items(singleItems), decode = FALSE));

head(singleSupport, n = 5);

itemsetList = LIST(items(fsets), decode = FALSE);

allConfidence = quality(fsets)$support / sapply(itemsetList, function(x)
  
  max(singleSupport[as.character(x)]));

quality(fsets) = cbind(quality(fsets), allConfidence);

summary(fsets);
#-----------------------------------------------


#sort rules by decreasing lift
inspect(sort(rules, by = 'lift')[1:10])# getting first 10 rules that have 10 highest rules
#sort rules with 10 highest rules
#-------------------------
#advanced model like calaborative filtering, user profiles,neighbourhood model, lateinfect rule
#------------------------------
#try your own
#product purchased 4 times a day