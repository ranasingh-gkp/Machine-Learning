#Survival Analysis Basics
#http://www.sthda.com/english/wiki/survival-analysis-basics
#--------------------------------------------
#Survival analysis corresponds to a set of statistical approaches used to investigate the time it takes for an event of interest to occur.
#Survival analysis is used in a variety of field such as:
  #Cancer studies for patients survival time analyses,
  #Sociology for "event-history analysis",
  #and in engineering for "failure-time analysis".
#In cancer studies, typical research questions are like:
    #What is the impact of certain clinical characteristics on patient's survival
    #What is the probability that an individual survives 3 years?
    #Are there differences in survival between groups of patients?
#------------------Objectives----------------------
#The aim of this chapter is to describe the basic concepts of survival analysis. In cancer studies, most of survival analyses use the following methods:
    #Kaplan-Meier plots to visualize survival curves
    #Log-rank test to compare the survival curves of two or more groups
    #Cox proportional hazards regression to describe the effect of variables on survival. The Cox model is discussed in the next chapter: Cox proportional hazards model.
#----Basic concepts
#Survival time and event
#Censoring
#Survival function and hazard function
#//////1)Survival time and event
#Relapse
#Progression
#Death
#The time from 'response to treatment' (complete remission) to the occurrence of the event of interest is commonly called survival time (or time to event).
#The two most important measures in cancer studies include: i) the time to death; and
#ii) the relapse-free survival time, which corresponds to the time between response to treatment and recurrence of the disease. It's also known as disease-free survival time and event-free survival time.

#//////2)Censoring
#Censoring may arise in the following ways:
  
#  a patient has not (yet) experienced the event of interest, such as relapse or death, within the study time period;
#a patient is lost to follow-up during the study period;
#a patient experiences a different event that makes further follow-up impossible.
#This type of censoring, named right censoring, is handled in survival analysis.
#///////3)Survival and hazard functions
#The survival probability, also known as the survivor function S(t), is the probability that an individual survives from the time origin (e.g. diagnosis of cancer) to a specified future time t.

#The hazard, denoted by h(t), is the probability that an individual who is under observation at a time t has an event at that time.
#-------Kaplan-Meier survival estimate
#The Kaplan-Meier (KM) method is a non-parametric method used to estimate the survival probability from observed survival times (Kaplan and Meier, 1958).
#The survival probability at time ti, S(ti), is calculated as follow:  S(ti)=S(ti???1)(1???di/ni)
#S(ti???1) = the probability of being alive at ti???1
#ni = the number of patients alive just before ti
#di = the number of events at ti
#t0 = 0, S(0) = 1
#The estimated probability (S(t)) is a step function that changes value only at the time of each event. It's also possible to compute confidence intervals for the survival probability.
#The KM survival curve, a plot of the KM survival probability against time, provides a useful summary of the data that can be used to estimate measures such as median survival time.
#------------Survival analysis in R------------------------
install.packages("survival") #survival for computing survival analyses
install.packages("survminer") #survminer for summarizing and visualizing the results of survival analysis

library(survival)
library(survminer)
data(lung)
head(lung)
#inst: Institution code
#time: Survival time in days
#status: censoring status 1=censored, 2=dead
#age: Age in years
#sex: Male=1 Female=2
#ph.ecog: ECOG performance score (0=good 5=dead)
#ph.karno: Karnofsky performance score (bad=0-good=100) rated by physician
#pat.karno: Karnofsky performance score as rated by patient
#meal.cal: Calories consumed at meals
#wt.loss: Weight loss in last six months
