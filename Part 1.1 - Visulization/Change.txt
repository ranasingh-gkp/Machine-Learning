#Time Series Plot From a Time Series Object (ts)
#The ggfortify package allows autoplot to automatically plot directly from a time series object (ts).
install.packages("ggfortify")
data(AirPassengers)
AirPassengers
library(ggplot2)
library(ggfortify)
theme_set(theme_classic())

# Plot 
autoplot(AirPassengers) + 
  labs(title="AirPassengers") + 
  theme(plot.title = element_text(hjust=0.5))

#--------------------------------------------------------------------------
#Time Series Plot From a Data Frame
library(ggplot2)
data(economics)
economics
theme_set(theme_classic())
economics$returns_perc <- c(0, diff(economics$psavert)/economics$psavert[-length(economics$psavert)])
# Allow Default X Axis Labels
ggplot(economics, aes(x=date)) + 
  geom_line(aes(y=returns_perc)) + 
  labs(title="Time Series Chart", 
       subtitle="Returns Percentage from 'Economics' Dataset", 
       caption="Source: Economics", 
       y="Returns %")
#---------------------------------------------------------------------------
#Time Series Plot For a Monthly Time Series
#If you want to set your own time intervals (breaks) in X axis, you need to set the breaks and labels using scale_x_date()
library(ggplot2)
library(lubridate)
theme_set(theme_bw())
economics$returns_perc <- c(0, diff(economics$psavert)/economics$psavert[-length(economics$psavert)])
economics_m <- economics[1:24, ]

# labels and breaks for X axis text
lbls <- paste0(month.abb[month(economics_m$date)], " ", lubridate::year(economics_m$date))
brks <- economics_m$date

# plot
ggplot(economics_m, aes(x=date)) + 
  geom_line(aes(y=returns_perc)) + 
  labs(title="Monthly Time Series", 
       subtitle="Returns Percentage from Economics Dataset", 
       caption="Source: Economics", 
       y="Returns %") +  # title and caption
  scale_x_date(labels = lbls, 
               breaks = brks) +  # change to monthly ticks and labels
  theme(axis.text.x = element_text(angle = 90, vjust=0.5),  # rotate x axis text
        panel.grid.minor = element_blank())  # turn off minor grid
#------------------------------------------------------------------------------------------------------
#Time Series Plot For a Yearly Time Series
library(ggplot2)
library(lubridate)
theme_set(theme_bw())
economics$returns_perc <- c(0, diff(economics$psavert)/economics$psavert[-length(economics$psavert)])
economics_y <- economics[1:90, ]

# labels and breaks for X axis text
brks <- economics_y$date[seq(1, length(economics_y$date), 12)]
lbls <- lubridate::year(brks)
# Compute % Returns


# plot
ggplot(economics_y, aes(x=date)) + 
  geom_line(aes(y=returns_perc)) + 
  labs(title="Yearly Time Series", 
       subtitle="Returns Percentage from Economics Dataset", 
       caption="Source: Economics", 
       y="Returns %") +  # title and caption
  scale_x_date(labels = lbls, 
               breaks = brks) +  # change to monthly ticks and labels
  theme(axis.text.x = element_text(angle = 90, vjust=0.5),  # rotate x axis text
        panel.grid.minor = element_blank())  # turn off minor grid
#--------------------------------------------------------------------------------------------
#Time Series Plot From Long Data Format: Multiple Time Series in Same Dataframe Column
data(economics_long, package = "ggplot2")
head(econlibrary(ggplot2)
     library(lubridate)
     theme_set(theme_bw())
     
     df <- economics_long[economics_long$variable %in% c("psavert", "uempmed"), ]
     df <- df[lubridate::year(df$date) %in% c(1967:1981), ]
     
     # labels and breaks for X axis text
     brks <- df$date[seq(1, length(df$date), 12)]
     lbls <- lubridate::year(brks)
     
     # plot
     ggplot(df, aes(x=date)) + 
       geom_line(aes(y=value, col=variable)) + 
       labs(title="Time Series of Returns Percentage", 
            subtitle="Drawn from Long Data format", 
            caption="Source: Economics", 
            y="Returns %", 
            color=NULL) +  # title and caption
       scale_x_date(labels = lbls, breaks = brks) +  # change to monthly ticks and labels
       scale_color_manual(labels = c("psavert", "uempmed"), 
                          values = c("psavert"="#00ba38", "uempmed"="#f8766d")) +  # line color
       theme(axis.text.x = element_text(angle = 90, vjust=0.5, size = 8),  # rotate x axis text
             panel.grid.minor = element_blank())  # turn off minor gridomics_long)
#-----------------------------------------------------------------------------------------------------------
     #Time Series Plot From Wide Data Format: Data in Multiple Columns of Dataframe
     library(ggplot2)
     library(lubridate)
     theme_set(theme_bw())
     economics$returns_perc <- c(0, diff(economics$psavert)/economics$psavert[-length(economics$psavert)])
     df <- economics[, c("date", "psavert", "uempmed")]
     df <- df[lubridate::year(df$date) %in% c(1967:1981), ]
     
     # labels and breaks for X axis text
     brks <- df$date[seq(1, length(df$date), 12)]
     lbls <- lubridate::year(brks)
     
     # plot
     ggplot(df, aes(x=date)) + 
       geom_line(aes(y=psavert, col="psavert")) + 
       geom_line(aes(y=uempmed, col="uempmed")) + 
       labs(title="Time Series of Returns Percentage", 
            subtitle="Drawn From Wide Data format", 
            caption="Source: Economics", y="Returns %") +  # title and caption
       scale_x_date(labels = lbls, breaks = brks) +  # change to monthly ticks and labels
       scale_color_manual(name="", 
                          values = c("psavert"="#00ba38", "uempmed"="#f8766d")) +  # line color
       theme(panel.grid.minor = element_blank())  # turn off minor grid
#-----------------------------------------------------------------------------------------------------------------
#Stacked Area Chart
#Stacked area chart is just like a line chart, except that the region below the plot is all colored. This is typically used when:
     
  #   You want to describe how a quantity or volume (rather than something like price) changed over time
   #  You have many data points. For very few data points, consider plotting a bar chart.
    # You want to show the contribution from individual components.
     library(ggplot2)
     library(lubridate)
     theme_set(theme_bw())
     
     df <- economics[, c("date", "psavert", "uempmed")]
     df <- df[lubridate::year(df$date) %in% c(1967:1981), ]
     
     # labels and breaks for X axis text
     brks <- df$date[seq(1, length(df$date), 12)]
     lbls <- lubridate::year(brks)
     
     # plot
     ggplot(df, aes(x=date)) + 
       geom_area(aes(y=psavert+uempmed, fill="psavert")) + 
       geom_area(aes(y=uempmed, fill="uempmed")) + 
       labs(title="Area Chart of Returns Percentage", 
            subtitle="From Wide Data format", 
            caption="Source: Economics", 
            y="Returns %") +  # title and caption
       scale_x_date(labels = lbls, breaks = brks) +  # change to monthly ticks and labels
       scale_fill_manual(name="", 
                         values = c("psavert"="#00ba38", "uempmed"="#f8766d")) +  # line color
       theme(panel.grid.minor = element_blank())  # turn off minor grid
#------------------------------------------------------------------------------------------------------------------
     #Slope Chart
#This is more suitable over a time series when there are very few time points.
     library(dplyr)
     theme_set(theme_classic())
     source_df <- read.csv("https://raw.githubusercontent.com/jkeirstead/r-slopegraph/master/cancer_survival_rates.csv")
     
     # Define functions. Source: https://github.com/jkeirstead/r-slopegraph
     tufte_sort <- function(df, x="year", y="value", group="group", method="tufte", min.space=0.05) {
       ## First rename the columns for consistency
       ids <- match(c(x, y, group), names(df))
       df <- df[,ids]
       names(df) <- c("x", "y", "group")
       
       ## Expand grid to ensure every combination has a defined value
       tmp <- expand.grid(x=unique(df$x), group=unique(df$group))
       tmp <- merge(df, tmp, all.y=TRUE)
       df <- mutate(tmp, y=ifelse(is.na(y), 0, y))
       
       ## Cast into a matrix shape and arrange by first column
       require(reshape2)
       tmp <- dcast(df, group ~ x, value.var="y")
       ord <- order(tmp[,2])
       tmp <- tmp[ord,]
       
       min.space <- min.space*diff(range(tmp[,-1]))
       yshift <- numeric(nrow(tmp))
       ## Start at "bottom" row
       ## Repeat for rest of the rows until you hit the top
       for (i in 2:nrow(tmp)) {
         ## Shift subsequent row up by equal space so gap between
         ## two entries is >= minimum
         mat <- as.matrix(tmp[(i-1):i, -1])
         d.min <- min(diff(mat))
         yshift[i] <- ifelse(d.min < min.space, min.space - d.min, 0)
       }
       
       
       tmp <- cbind(tmp, yshift=cumsum(yshift))
       
       scale <- 1
       tmp <- melt(tmp, id=c("group", "yshift"), variable.name="x", value.name="y")
       ## Store these gaps in a separate variable so that they can be scaled ypos = a*yshift + y
       
       tmp <- transform(tmp, ypos=y + scale*yshift)
       return(tmp)
       
     }
     
     plot_slopegraph <- function(df) {
       ylabs <- subset(df, x==head(x,1))$group
       yvals <- subset(df, x==head(x,1))$ypos
       fontSize <- 3
       gg <- ggplot(df,aes(x=x,y=ypos)) +
         geom_line(aes(group=group),colour="grey80") +
         geom_point(colour="white",size=8) +
         geom_text(aes(label=y), size=fontSize, family="American Typewriter") +
         scale_y_continuous(name="", breaks=yvals, labels=ylabs)
       return(gg)
     }    
     
     ## Prepare data    
     df <- tufte_sort(source_df, 
                      x="year", 
                      y="value", 
                      group="group", 
                      method="tufte", 
                      min.space=0.05)
     
     df <- transform(df, 
                     x=factor(x, levels=c(5,10,15,20), 
                              labels=c("5 years","10 years","15 years","20 years")), 
                     y=round(y))
     
     ## Plot
     plot_slopegraph(df) + labs(title="Estimates of % survival rates") + 
       theme(axis.title=element_blank(),
             axis.ticks = element_blank(),
             plot.title = element_text(hjust=0.5,
                                       family = "American Typewriter",
                                       face="bold"),
             axis.text = element_text(family = "American Typewriter",
                                      face="bold"))
#---------------------------------------------------------------------------------------------------------------
#Seasonal Plot
library(ggseasonplot)
library(ggplot2)
install.packages("ggseasonplot")
library(forecast)
theme_set(theme_classic())
data(AirPassengers)
 # Subset data
 nottem_small <- window(nottem, start=c(1920, 1), end=c(1925, 12))  # subset a smaller timewindow
 nottem_small
     # Plot
     ggseasonplot(AirPassengers) + labs(title="Seasonal plot: International Airline Passengers")
     ggseasonplot(nottem_small) + labs(title="Seasonal plot: Air temperatures at Nottingham Castle")
     