
#APRIORI
#association rules model here used
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

#importing data set
dataset = pd.read_csv('Market_Basket_Optimisation.csv', header = None)
#Apriori do not take  csv file directly, it convert into sparse matrix.
#sparse matrix is matrix contain lot of zero
#now prepare the list of all transiction stored by i and each transiction itself stored as list by j
transactions = []
for i in range(0, 7501):
    transactions.append([str(dataset.values[i,j]) for j in range(0, 20)])

# Training Apriori on the dataset
from apyori import apriori
rules = apriori(transactions, min_support = 0.003, min_confidence = 0.2, min_lift = 3, min_length = 2)
#set minimum lift  3, to get valualbe result
#support here is that the items contain in basket must have minimum support of 0.0028 
# all rules must be taken higher confidence then minimum confidence 0.2
#support is items purchased 3 to 4 in a day multiply by no of week for this problem and overall divided by total transiction of weeks.
#(3*7 per week)/7500
# confidence is by assumption but we dont need very high confident but not very small
#start confidence with default value (0.8) then decrease one by one by analyzing result
#the most important factor is rules 
#each rules must be currect for 80% of transiction

# Visualising the results
results = list(rules)










