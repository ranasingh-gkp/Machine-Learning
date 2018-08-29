#Confounding Variable
#-----------------------------------
#A Confounding variable is an important variable that should be included in the predictive model but you omit it.
#Naive interpretation of such models can lead to invalid conclusions.
#For example, consider that we want to model life expentency in different countries based on the GDP per capita, using the gapminder data set:
install.packages("gapminder")
library(gapminder)
lm(lifeExp ~ gdpPercap, data = gapminder)
#it is clear that the continent is an important variable: countries in Europe are estimated to have a higher life expectancy compared to countries in Africa.
#Therefore, continent is a confounding variable that should be included in the model:
lm(lifeExp ~ gdpPercap + continent, data = gapminder)
