#http://www.sthda.com/english/wiki/chi-square-test-of-independence-in-r
housetasks <- read.delim(testiq, row.names = 1)
head(testiq)
install.packages("gplots")
library(gplots)
# 1. convert the data as a table
dt <- as.table(as.matrix(testiq))
# 2. Graph
balloonplot(t(dt), main ="testiq", xlab ="", ylab="",
            label = FALSE, show.margins = FALSE)
library("graphics")
mosaicplot(dt, shade = TRUE, las=2,main = "testiq")
#install.packages("vcd")
library("vcd")
# plot just a subset of the table
assoc(head(dt, 5), shade = TRUE, las=3)
chisq.test(testiq)
# Observed counts
chisq$observed
# Expected counts
round(chisq$expected,2)
#Pearson residuals can be easily extracted from the output of the function chisq.test(
round(chisq$residuals, 3)
#Let's visualize Pearson residuals using the package corrplot
library(corrplot)
corrplot(chisq$residuals, is.cor = FALSE)
# Contibution in percentage (%)
contrib <- 100*chisq$residuals^2/chisq$statistic
round(contrib, 3)
# Visualize the contribution
corrplot(contrib, is.cor = FALSE)
# printing the p-value
chisq$p.value
# printing the mean
chisq$estimate