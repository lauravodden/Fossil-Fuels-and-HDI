# Vodden, Laura MA5820
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ASSIGNMENT 3 CAPSTONE PROJECT R CODE~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
###########################################################################################################
# Set libraries
library(tidyr)
library(dplyr)
library(ggplot2)
library(ggpubr)

# RStudio Version
RStudio.Version()

# Set working directory
setwd('C:/Users/laura/OneDrive/Desktop/MA5820/Assignment_3')

# Import HDI data
HDI_Data <- read.csv("hdi_human_development_index.csv")
CO2_per_person_Data <- read.csv("co2_emissions_tonnes_per_person.csv")
Total_CO2_Data <- read.csv("yearly_co2_emissions_1000_tonnes.csv")


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~DATA CLEANING~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Select 1990-2014 data for HDI, CO2, Forest and Land data

HDI_Data <- select(HDI_Data,-c(2:25,27))
names(HDI_Data) <- gsub("X2014", "HDI", names(HDI_Data))
HDI_Data

HDI_num_Data <- HDI_Data
names(HDI_num_Data) <- gsub("HDI", "HDI_num", names(HDI_num_Data))
HDI_num_Data

CO2_per_person_Data <- select(CO2_per_person_Data,-c(2:215))
names(CO2_per_person_Data) <- gsub("X2014", "CO2_pp", names(CO2_per_person_Data))
CO2_per_person_Data

Total_CO2_Data <- select(Total_CO2_Data,-c(2:264))
names(Total_CO2_Data) <- gsub("X2014", "Total_CO2", names(Total_CO2_Data))
Total_CO2_Data


# For HDI_Data, convert numerical values to categorical variables
# Low: 0.0-0.5
# Medium: 0.5-0.8
# High: 0.8-1.0

HDI_Data$HDI[HDI_Data$HDI < 0.5] = "Low"
HDI_Data$HDI[HDI_Data$HDI < 0.8] = "Medium"
HDI_Data$HDI[HDI_Data$HDI < 1.0] = "High"


# Merge HDI, CO2 and forest dataframes
# 135 obs of 76 variables
Data_2014 <- left_join(HDI_Data, CO2_per_person_Data)
Data_2014 <- left_join(Data_2014, Total_CO2_Data)
Data_2014


# Remove missing data
Data_2014 <- na.omit(Data_2014)

# Create population variable
Data_2014$Population <- (Data_2014$Total_CO2)*1000 / Data_2014$CO2_pp

# Ensure low, medium and high stay in order for plots
Data_2014$HDI <- factor(Data_2014$HDI,levels = c("Low", "Medium", "High"))

# Generate random dataset of 100 for following objectives
set.seed(100)
index <- sample(1:nrow(Data_2014), 100)
index

Data_2014 <- Data_2014[index, ]

Data_2014

write.csv(Data_2014,'Data_2014.csv')

###################################################################################################################
# Objective 1
# Test whether there is a difference between total CO2 emissions in high and low HDI countries


# Remove 'medium' HDI countries form dataset
High_Low_HDI <- Data_2014[!(Data_2014$HDI=="Medium"),]

# Exploratory data analysis
HDI_Total_CO2_plot <- ggplot(data = High_Low_HDI) +
  geom_boxplot(mapping = aes(x = HDI, y = Total_CO2),  outlier.size = 1) +
  ylim(0,60000)
HDI_Total_CO2_plot + labs(title = "Total CO2 Emissions by HDI Category")


# State the hypotheses
# The null hypothesis is that the population median for total CO2 emissions for high HDI countries 
# is different from the population median for total CO2 emissions for low HDI countries.
# Alternative hypothesis is that there is a difference.

# State the significance level
# This is the probability of committing a type I error. We use the common significance level of 5% here. 
# Therefore ??=0.05.


# Check assumptions (at least 11 cases for both low and high HDI)




# Perform two-sample Wilcoxon test on new dataset
zw=wilcox.test(Total_CO2 ~ HDI, data=High_Low_HDI,alternative="two.sided",mu=0) 
zw
# Sometimes if there are tied ranks, R will give an error message noting that 
# the exact p-value can not be computed and is thus an approximation

# p-value = 0.0001043
# There is sufficient evidence to suggest that high HDI countries have greater CO2 
# emissions than low HDI countries.


###################################################################################################################
# Objective 2
#Test whether CO2 emissions per person increases countries with HDI

Data_2014
qqnorm(Data_2014$CO2_pp)
qqline(Data_2014$CO2_pp)


# Remove outliers
mean_Data_2014 <- mean(Data_2014$CO2_pp)
sd_Data_2014 <- mean_Data_2014*2.2
Data_2014_OM <- Data_2014[ which(Data_2014$CO2_pp < sd_Data_2014), ]

qqnorm(Data_2014_OM$CO2_pp)
qqline(Data_2014_OM$CO2_pp)


# Subset data
Low_HDI <- subset(Data_2014_OM, HDI == "Low")
High_HDI <- subset(Data_2014_OM, HDI == "High")

par(mfrow=c(1,2))
qqnorm(Low_HDI$CO2_pp)
qqline(Low_HDI$CO2_pp)
qqnorm(High_HDI$CO2_pp)
qqline(High_HDI$CO2_pp)




# State the hypotheses
# The null hypothesis is that there is no difference in CO2 emissions between the two HDI categories. 
# That is, the mean of CO2 emissions is the same for both HDI categories.
#The alternative hypothesis is that the mean CO2 emissions are higher in the high HDI category compared to 
# the low HDI category.

#H0:??Low = ??High
#HA:??High > ??Low

# State the significance level
# This is the probability of committing a type I error. We use the common significance level of 5% here. 
# Therefore ??=0.05.


#The two-sample t-test assumes:
# The data are a simple random sample. We assume that the cabbages grown are a representative 
# sample of the entire population of cabbages of the same cultivar type.
#Observations come from a population that is normally distributed. The Q-Q plot of the sample 
# data, shown above, indicates that this is a reasonable assumption.


# Perform a significance test
# two-sample T-test

sd(Low_HDI$CO2_pp)

sd(High_HDI$CO2_pp)

# These are reasonably close to allow us to assume equal variances in the calculation of the 
# standard error. Hence we use the formula:

xbar <- mean(High_HDI$CO2_pp)
ybar <- mean(Low_HDI$CO2_pp)
sx <- sd(High_HDI$CO2_pp)
sy <- sd(Low_HDI$CO2_pp)
nx <- nrow(High_HDI)
ny <- nrow(Low_HDI)

spsqr <- ((nx - 1)*sx^2 + (ny - 1)*sy^2) / (nx + ny - 2)

std.err <- sqrt(spsqr * (1/nx + 1/ny))

tstatistic <- (xbar - ybar) / std.err
tstatistic

degrees.freedom <- nx + ny - 2

print(paste("The t-statistic is",signif(tstatistic,4)))

print(paste("There are",degrees.freedom,"degrees of freedom."))

# Determine the rejection region
alpha = 0.05
tstar <- qt(1 - alpha, df=degrees.freedom)
tstar

print(paste("tstar is",signif(tstar,4)))

# The tstatistic lies in the rejection region, so we reject the null hypothesis.
par(mfrow=c(1,2))
qqnorm(Data_2014$CO2_pp)
qqline(Data_2014$CO2_pp)
qqnorm(Data_2014_OM$CO2_pp)
qqline(Data_2014_OM$CO2_pp)

degrees.freedom
tstatistic
tstar

###################################################################################################################
# Objective 3
# Regression analysis
# eg
# Test whether Population pp can be used to predict Total_CO2
# Perform a linear regression analysis, using Total_CO2 as the response variable 
# and Population as the predictor variable.

# Exploratory data analysis
# Normality
par(mfrow=c(2,2))
boxplot((Data_2014$Population), main="Population",
        ylab="Count")

boxplot((Data_2014$Total_CO2), main="Total CO2 (1000 metric t)",
        ylab="Count")

qqnorm(Data_2014$Population)
qqline(Data_2014$Population)

qqnorm(Data_2014$Total_CO2)
qqline(Data_2014$Total_CO2)

# Remove outliers
Data_2014_OM3 <- Data_2014[ which(Data_2014$Population < 10000000), ]

par(mfrow=c(2,2))
boxplot((Data_2014_OM3$Population), main="Population",
        ylab="Count")

boxplot((Data_2014_OM3$Total_CO2), main="Total CO2 (1000 metric t)",
        ylab="Count")

qqnorm(Data_2014_OM3$Population)
qqline(Data_2014_OM3$Population)

qqnorm(Data_2014_OM3$Total_CO2)
qqline(Data_2014_OM3$Total_CO2)
# Both Total_CO2 and Population data are approximately normally distributed.

# Scatterplot to visualise the relationship between Population and Total_CO2, remembering 
# that Total_CO2 is the response and should be plotted on the vertical axis.
par(mfrow=c(1,1))
plot(Data_2014_OM3$Population, Data_2014_OM3$Total_CO2, main="Population vs Total_CO2", xlab="Population", ylab="Total_CO2")

# Outliers have already been removed from the dataset

# Estimate the parameters using inbuilt R functions
zmodel <- lm(Total_CO2 ~ Population, data=Data_2014_OM3)

summary(zmodel)


# Compute the fitted values of the statistical model
Total_CO2.fitted <- predict(zmodel)

par(mar=par()$mar + c(0,1,0,0)) 
plot(Total_CO2.fitted, Data_2014_OM3$Total_CO2, main="Total_CO2 fitted values", xlab="Fitted values of Total_CO2", ylab="Actual values of Total_CO2")
abline(0,1, lty=2)
# If the fitted values were identical to the actual values, all the points would fall 
# on the line. This is not quite the case, but there is some correspondence between 
# the fitted values and the observed values of Total_CO2.

# Compute the residuals of the linear model
residuals <- resid(zmodel)



# After forming a linear model there are several aspects we should verify:
# Check that the assumptions of the residuals are satisfied.
# Check the R2 to determine if the explanatory power of the model is useful 
# (we do not want to use a model to make predictions if the R2 is too small).
# Check that the model passes important significance tests about the population 
# slope and population R2.

# Test the normal distribution of the residuals:
qqnorm(residuals)
qqline(residuals)
# The Q-Q plot shows the residuals are approximately normal.

# To test for constant variance we create a scatterplot of the residuals against 
# the fitted values. Ideally you should not see a pattern and the points should be 
# randomly scattered around the horizontal axis.
par(mfrow=c(1,2))
plot(Total_CO2.fitted, residuals, main="Constant variance", xlab="Fitted Total_CO2", ylab="Residual (years)")
abline(h=0, lty=2)
# The scatterplot shows that there is no discernible pattern to the residuals and 
# that it is therefore reasonable to assume the residuals meet the assumption of 
# constant variance.

# Finally, we check the independence of the residuals by plotting them in the sequence 
# in which they appeared in the data. We do not want this plot to show any trending or 
# cyclic features.
plot(residuals, type='b', main="Independence", ylab="Residual")

abline(h=0, lty=2, col='grey')
# There is no discernible pattern in the residuals which leads us to believe that the 
# assumption of independence for the residuals is valid.

# Compute the R squared value



# Test the significance
summary(zmodel)
#The R2 value indicates that 43.6% of the variability in CO2 emissions expectancy is 
#explained by the linear model.
# The p-value here is very small, giving us confidence that these data come from a 
# population whose R2 is different to zero. Equivalently, we can also be confident that 
# these data come from a population where there is a trend between Population 
# and Total_CO2.
# But not a very good one.


# Show the line of best fit and confidence and prediction bands for the model
xgrid <- seq(0, 80000000, length.out=101)
xgridframe <- data.frame(Population=xgrid)
pc <- predict(zmodel, xgridframe, interval="confidence")
pp <- predict(zmodel, xgridframe, interval="prediction")
fit <- pc[,1]
par(mfrow=c(1,1))
plot(Data_2014_OM3$Population, Data_2014_OM3$Total_CO2, main="Population as a predictor of total CO2 emissions", xlab="Population", ylab="Total_CO2")
lines(xgrid, fit)
matlines(xgrid, pc[,-1], col=1, lty=2)
matlines(xgrid, pp[,-1], col=1, lty=3)

legend(50000,70000, c("Line of best fit", "Confidence interval", "Prediction interval"), lty=c(1,2,3))


