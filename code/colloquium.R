rm(list = ls())

setwd("M:\My Drive\Levy MS\Graduate Programs\Recruitment\202411 Econ Sproj Colloquium")

##########################################################################
#  File: colloquium.do
#  Date: 2024-11-01
#  Author: Thomas Masterson
#  Purpose: provide guidance on the use of STATA for data management and 
#  analysis for Economics Senior Project Colloquium
##########################################################################

## Load libraries
library(openxlsx)

## Import the Penn World Tables
penn <- read.xlsx("Data/pwt1001.xlsx","Data")

## Summary statistics
# built-in base R:
summary(penn)

# skimr package
library(skimr)
skim(penn)

# vtable package
library(vtable)
st(penn)


## Make a frequency table
table1 <- table(penn$year)
table1

library(questionr)
(ftable1 <- freq(table1))

## Missing values handled
penn$high <- penn$rgdpo>150000
table(penn$high)

## Regression results
library(readstata13)
mroz <- read.dta13("Data/mroz.dta")

wage1 <- lm(lwage ~ exper + expersq + age + educ, data = mroz)

library(stargazer)
stargazer(wage1, type = "text", digits = 2,
          covariate.labels = c("Experience", 
                              "Experience Squared",
                              "Age", "Education"),
          title = "Wage determination using the Mroz data")

# Now run with the city variable
wage2 <- lm(lwage ~ exper + expersq + age + educ + city, data = mroz)

# Make the city variable in to a factor (even theough it is a dummy variable)
mroz$city_fac <- factor(mroz$city, c(0,1), c("Rural", "Urban"))

# Run the model
wage3 <- lm(lwage ~ exper + expersq + age + educ + city_fac, data = mroz)

# make a table with all three models
table2 <- stargazer(wage1, wage2, wage3, type = "text", digits = 2,
            covariate.labels = c("Experience", 
                               "Experience Squared",
                               "Age", "Education", 
                               "Location (dummy)", "Location (factor)"),
            title = "Wage determination using the Mroz data")
