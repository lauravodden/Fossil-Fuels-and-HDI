# Fossil-Fuels-and-HDI: Carbon emissions as an indicator of human human standards of living.
Laura Vodden



## Executive Summary
> Carbon dioxide (CO2) emissions are produced by burning fossil fuels, primarily as a source of energy (Olivier et al., 2012). It has been demonstrated that countries with the highest CO2 emissions have the wealthiest people and greates economic growth (Hickel, 2020; Holtz-Eakin & Selden, 1995; Jorgenson et al., 2017), and that there is global inequality in the production of carbon emissions, reflecting this (Chancel & Piketty, 2015; Oxfam, 2015).
> 
> While the wealth of a country is often expressed in terms of economic value, this is not the only measure of a country’s wealth (Hickel, 2020). The Human Development Index (HDI) is a measure of average human wellbeing in terms of health (measured by life expectancy), education (measured by mean years of schooling) and standard of living (measured by gross national income per capita). The HDI is the mean of the normalized indices for each of the three dimensions (UNDP, 2020).
This report aims to investigate the possibility that economic growth and human wellbeing go hand in hand, by comparing CO2 emissions with HDI and population data. To this end, the report will test:
> 
> * 1. Whether there is a difference between total CO2 emissions in high and low HDI countries;
> * 2. Whether CO2 emissions per person increase with HDI; and
> * 3. Whether a country’s population can be used to its total CO2 emissions.
> 
> In order to conduct this investigation, data was cleaned and analysed in RStudio, using the following methods to answer these three questions, respectively:
> 
> * 1. A two-sample Wilcoxon test
> * 2. A two-sample T-test
> * 3. A linear regression analysis
> 
> The report finds that there is a difference between CO2 emissions in high and low HDI countries, CO2 emissions do generally increase with HDI, and that population is not a good predictor for CO2 emissions and therefore HDI.
> 
> The conclusion drawn from this report is that a CO2 emissions (indicative of a country’s economic wealth) do tend to increase with the wellbeing of its people, as indicated by HDI. This suggests that economic wealth and human development go hand in hand, since the countries with the highest HDIs also had the highest CO2 emissions, however the countries producing the highest emissions were not necessarily the most populous, indicating that population is not a significant contributor to either HDI or CO2 emissions.


## Introduction
The Human Development Index (HDI) is an indicator of a country’s level of development, expressed as a unitless average of three dimensions: health, education and income (Wolff et al., 2011). A country’s development index can be categorised as low (0.0 to 0.5), medium (0.5 to 0.8) and high (0.8 to 1.0).

The HDI can be used to demonstrate global inequality in wealth, living standards and even carbon emissions (Chancel & Piketty, 2015; Oxfam, 2015). Motivated by an interest in how carbon emissions can highlight the uneven distribution of wealth, this report aims to use global environmental data from 2014 (the most recent Gapminder data available) to test whether there is a difference between total CO2 emissions in high and low HDI countries, whether CO2 emissions per person
increase with HDI, and whether a country’s population can be used to its total CO2 emissions.


## Data
The software used in the analysis is R version 1.2.5033 (Orange Blossom). The data used in the following analyses can be accessed from the Gapminder.org website. Specifically, environmental data comprises Total CO2 emissions (measured in tonnes), and CO2 emissions per person (measured in tonnes per person), These datasets provided numeric variables to be compared against Human Development Index (HDI) data, which can be accessed from the ‘Society’ section of the Gapminder website.

Initially, the data comprised a population size of up to 192 countries (depending on the data accessed). Prior to commencing the analyses, however, some data cleaning was required. Firstly, only data from the year 2014 were retained, using the select() function. 2014 data were chosen because this was the most recent year with data available for all variables of interest and therefore the most representative of the current global situation. Secondly, in order to more easily measure the numeric variables against HDI in a meaningful way, the HDI data were grouped into three categories: ‘low’, ‘medium’ and ‘high’, in accordance with those categories set by the UN (Hickel, 2020; Wolff et al., 2011).The following code achieved this:

    HDI_Data$HDI[HDI_Data$HDI < 0.5] = "Low" 
    HDI_Data$HDI[HDI_Data$HDI < 0.8] = "Medium" 
    HDI_Data$HDI[HDI_Data$HDI < 1.0] = "High"
    
A new dataframe was compiled, using <b>left_join()</b>, comprising the 2014 data for the HDI data as well as the environmental data relating to CO2 emissions. Missing data were removed using <b>na.omit()</b> and a new variable (population) was generated by dividing Total_CO2 by CO2 emissions per person:

    Data_2014$Population <- (Data_2014$Total_CO2)*1000 / Data_2014$CO2_pp
    
Finally, it must be noted that data available are not a random sample. The data include a population of all countries for which Gapminder data are available. In order to satisfy the requirements for any significance test, and to try to avoid any bias inherent in the original population data, a random sample of 100 countries was generated, using the <b>sample()</b> function. A selection of the resulting dataframe is shown in <i>Table 1</i>. Each of the three objectives covered in this report will refer to this random sample. <i>Table 2</i> provides further detail about the variables used. The full dataframe can be viewed in <i>Appendix 1</i>.


![Tab1](https://user-images.githubusercontent.com/70361071/116188499-dbbe8400-a76a-11eb-936a-6f01c729e56c.JPG)



## Objective 1: Emission inequality: Test whether there is a difference between total CO2 emissions in high and low HDI countries.
Using data from the categorical HDI and numeric Total_CO2 variables, the first objective tests whether high HDI countries and low HDI countries have different total CO2 emissions, and therefore whether carbon emission inequality can be demonstrated.

### Methods     
#### Exploratory data analysis
A boxplot provided the first look at the difference between the distribution of data for high and low HDI countries. This was achieved using the geom_boxplot() function from the ggplot2 package to plot HDI on the x axis and Total_CO2 on the y axis. Figure 1 shows that the range of total CO2 emissions for high HDI countries is much greater than that for low HDI countries. The y axis limit has been set to 60000 to prevent data from being drowned out by outliers in the high HDI category.

Initially, the intention was to perform a two-sample t-test on these data. However, removal of the outliers resulted in removal of specifically high HDI countries from the dataset. This meant that any mean taken for the high HDI countries would not be representative of reality and introduced unwanted bias to the analysis. It was therefore decided that using a nonparametric test would provide a more accurate result, since for nonparametric tests, outliers and deviations from normality do not affect the ability of the test to be performed (Ramdas et al., 2017).

In this case, a two-sample Wilcoxon test was deemed appropriate, as it is the nonparametric equivalent of the two sample t-test, and tests for the median of the sample (Verzani, 2014), which was likely to be more descriptive of the sample than the mean in this case.
               
#### Hypotheses
The null hypothesis for this significance test was that the sample median for total CO2 emissions for high HDI countries would be different from the sample median for total CO2 emissions for low HDI countries. The alternative hypothesis was that there would be difference. This is expressed as:

            H0: M = 1310
            HA: M ≠ 1310
                      
#### Significance level of the test
The significance level (or the probability of committing a type-1 error) of this test was 5%. Therefore, α = 0.05.
             
#### Statistical test and assumptions
A two-sample Wilcoxon test assumes that both datasets simple random samples, and that each has at least 11 cases, both of which were satisfied in this scenario. The test was run using the following code: wilcox.test(Total_CO2 ~ HDI, data=High_Low_HDI,alternative="two.sided",mu=0)
              
#### Results and Discussion
The results of the two sample Wilcoxon test showed that there is sufficient evidence to suggest there is a difference between the CO2 emissions for high and low HDI countries (p-value = 0.0001254). In effect, carbon emission inequality has be demonstrated.
This result agrees with the preliminary analysis shown in Figure 1. The boxplot shows that there is a much different distribution of CO2 data for high HDI countries and low HDI countries. This result agrees with existing studies showing that show there is global inequality in carbon emission production (Chancel & Piketty, 2015; Oxfam, 2015).


## Objective 2: Test whether CO2 emissions per person increase with HDI.
Objective 2 seeks to determine the nature of the difference between CO2 emissions in high and low HDI countries, by testing if CO2 emissions per person increase with HDI.

### Methods

#### Exploratory data analysis
The first step in analysing the CO2_pp data was to test for normality. The qqnorm() and qqline() functions were used, to visualise the distribution of CO2_pp data, before and after removing outliers (Figure 2).

The qqplot indicates that the data were already approximately normal, however, there were some outliers in the data, which, when removed, resulted in the normal distribution in Figure 2 (right).

#### Hypotheses
The null hypothesis was that there would be no difference in CO2 emissions between the two HDI categories. That is, the mean of CO2 emissions is the same for both HDI categories. The alternative hypothesis was that the mean CO2 emissions would be higher in the high HDI category compared to the low HDI category.

        H0: μLow = μHigh
        HA: μHigh > μLow

#### Significance level of the test
As for objective 1, the significance level is 5% (α = 0.05).

#### Statistical test and assumptions
Solving this objective required a two-sample t-test. This test assumes that the data are a simple random sample and that observations come from a population that is normally distributed. Both of these requirements were satisfied; the data were from a random sample of 100 counties, and the qqplots confirmed the normality of the distribution.

In order to perform this test, it was necessary to subset the Data_2014 data using the subset() function, so that there were two datasets to compare: one for high HDI countries and one for low HDI countries. The following code achieved this:

        Low_HDI <- subset(Data_2014_OM, HDI == "Low") High_HDI <- subset(Data_2014_OM, HDI == "High")
        
Figure 3 shows that the individual datasets are both approximately normally distributed, high HDI more so than low HDI.

#### Results and Discussion 
The resulting t-statistic for the two-sample t-test was 10.52, while the tstar value returned was 1.697.
Because the tstatistic fell within the rejection region, the null hypothesis was rejected. Therefore, there is sufficient evidence to suggest that CO2 emissions per person increases with HDI.

This is a logical result. Countries with access to greater amounts of power naturally produce more CO2 emissions (Hickel, 2020). Since power is costly, countries that use the most power should be those that are wealthier (Chancel and Piketty, 2015) with good health, education and employment prospects, so countries with higher carbon emissions should generally have a higher HDI.


## Objective 3: Test whether a country’s population can be used to predict that country’s CO2 emissions.
The final objective this report aims to address is whether population can be used to predict a country’s CO2 emissions.

### Methods

#### Exploratory data analysis
For this objective, population data and Total_CO2 data were used. Figure 4 shows the preliminary box and scatter plots for both variables, showing that there was a small number of extreme outliers.

The most severely outlying data (countries with populations higher than one billion) were removed from the sample, resulting in the plots shown in Figure 5

#### Hypotheses
The hypothesis being tested is that population data can be used to predict a country’s CO2 emissions.

#### Estimate the parameters
Base R functions were used in the linear regression analysis. To find the regression coefficients, a linear model was created using lm() and output coefficients of the model were found using summary(), which can be viewed in Appendix 4.
The Rsquared value shows that only 43% of the variability in CO2 emissions can be explained by this model.

#### Compute fitted values of statistical model
In order to compute the fitted values of the model, the predict() function was used, and the observed values were plotted against the fitted values. In Figure 6, the fitted values do not fall on the line, so are not identical to the actual values; in fact, there was little correspondence between the fitted values and the observed values of Total_CO2.


#### Residuals 
The residuals are the difference between the prediction and the observed values, using the resid() function. Residuals are assumed to have a normal distribution, constant variance and be approximately independent. The first of these is satisfied, as shown in Figure 7.

Figure 8 shows that there is no pattern to the residuals. It is reasonable, therefore, to assume that the assumption of constant variance is met. The residuals were plotted in the sequence in which they appeared in the data. Once again, there is no pattern to the data, so the final assumption is satisfied.

#### Test the significance
The summary() function gave a t-statistic of 6.518, an F-statistic of 42.18, and a p-value of 2.318e-08, with 55 degrees of freedom. The very low p-value indicates that there is some trend between population and CO2 emissions.

#### Results and Discussion
Figure 9 shows the data plotted with confidence and prediction intervals.

The confidence bands show the uncertainty about the line of best fit, and the prediction bands reflect the uncertainty in the prediction of future observations. The prediction lines are quite wide, reducing confidence in the predictions derived from this linear model. Therefore, a country’s population cannot be used as a very reliable predictor of its CO2 emissions; however, because there is some correlation between the two variables, further investigation into this may be warranted.

## Concluding Remarks
This analysis has demonstrated that there is global inequality in carbon emissions, linked to wealth and wellbeing. The study has also demonstrated that it is possible to link carbon emissions to HDI; there is sufficient evidence to suggest that as a country’s carbon emissions increase, so too does its citizens’ standard of living.
