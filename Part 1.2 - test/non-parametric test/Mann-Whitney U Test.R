data("mtcars")
mtcars
# independent 2-group Mann-Whitney U Test 
wilcox.test(mpg~am, data = mtcars) 
# where y is numeric and A is A binary factor

# independent 2-group Mann-Whitney U Test
wilcox.test(y,x) # where y and x are numeric

# dependent 2-group Wilcoxon Signed Rank Test 
wilcox.test(y1,y2,paired=TRUE) # where y1 and y2 are numeric

# Kruskal Wallis Test One Way Anova by Ranks 
kruskal.test(y~A) # where y1 is numeric and A is a factor

# Randomized Block Design - Friedman Test 
friedman.test(y~A|B)
# where y are the data values, A is a grouping factor
# and B is a blocking factor

