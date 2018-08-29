Newey-West test

#Newey-West HAC...... Covariance Matrix Estimation
#NeweyWest(x, lag = NULL, order.by = NULL, prewhite = TRUE, adjust = FALSE,diagnostics = FALSE, sandwich = TRUE, ar.method = "ols", data = list(),verbose = FALSE)
#bwNeweyWest(x, order.by = NULL, kernel = c("Bartlett", "Parzen","Quadratic Spectral", "Truncated", "Tukey-Hanning"), weights = NULL,prewhite = 1, ar.method = "ols", data = list(), .)
install.packages("sandwich")
library(sandwich)
install.packages("NeweyWest")
library(NeweyWest)
fm <- lm(pred ~ ., data=data_all)

## Newey & West (1994) compute this type of estimator
NeweyWest(fm)

## The Newey & West (1987) estimator requires specification
## of the lag and suppression of prewhitening
NeweyWest(fm, lag = 4, prewhite = FALSE)

## bwNeweyWest() can also be passed to kernHAC(), e.g.
## for the quadratic spectral kernel
kernHAC(fm, bw = bwNeweyWest)
# }