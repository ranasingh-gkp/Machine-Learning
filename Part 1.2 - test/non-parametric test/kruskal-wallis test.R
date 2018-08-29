kruskal-wallis test
if(!require(dplyr)){install.packages("dplyr")}
if(!require(FSA)){install.packages("FSA")}
if(!require(DescTools)){install.packages("DescTools")}
if(!require(rcompanion)){install.packages("rcompanion")}
if(!require(multcompView)){install.packages("multcompView")}
Input =("
Group      Value
group.1    104
group.1    110
group.1    106
group.1    102
group.2    112
group.2   117
group.2   115
group.2   114
group.3   120
group.3   126
group.3   121
group.3   128
")
Data = read.table(textConnection(Input),header=TRUE)
### Specify the order of factor levels

library(dplyr)

Data = 
  mutate(Data,
         Group = factor(Group, levels=unique(Group)))
library(FSA)

Summarize(Value ~ Group,
          data = Data)
library(lattice)

histogram(~ Value | Group,  data=Data,layout=c(1,3))      #  columns and rows of individual plots
kruskal.test(Value ~ Group,data = Data)
