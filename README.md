# Fossil-Fuels-and-HDI: Carbon emissions as an indicator of human human standards of living.
Laura Vodden


## Executive Summary
Carbon dioxide (CO2) emissions are produced by burning fossil fuels, primarily as a source of energy (Olivier et al., 2012). It has been demonstrated that countries with the highest CO2 emissions have the wealthiest people and greates economic growth (Hickel, 2020; Holtz-Eakin & Selden, 1995; Jorgenson et al., 2017), and that there is global inequality in the production of carbon emissions, reflecting this (Chancel & Piketty, 2015; Oxfam, 2015).

While the wealth of a country is often expressed in terms of economic value, this is not the only measure of a country’s wealth (Hickel, 2020). The Human Development Index (HDI) is a measure of average human wellbeing in terms of health (measured by life expectancy), education (measured by mean years of schooling) and standard of living (measured by gross national income per capita). The HDI is the mean of the normalized indices for each of the three dimensions (UNDP, 2020).
This report aims to investigate the possibility that economic growth and human wellbeing go hand in hand, by comparing CO2 emissions with HDI and population data. To this end, the report will test:

* 1. Whether there is a difference between total CO2 emissions in high and low HDI countries;
* 2. Whether CO2 emissions per person increase with HDI; and
* 3. Whether a country’s population can be used to its total CO2 emissions.

In order to conduct this investigation, data was cleaned and analysed in RStudio, using the following methods to answer these three questions, respectively:

* 1. A two-sample Wilcoxon test
* 2. A two-sample T-test
* 3. A linear regression analysis
*
The report finds that there is a difference between CO2 emissions in high and low HDI countries, CO2 emissions do generally increase with HDI, and that population is not a good predictor for CO2 emissions and therefore HDI.

The conclusion drawn from this report is that a CO2 emissions (indicative of a country’s economic wealth) do tend to increase with the wellbeing of its people, as indicated by HDI. This suggests that economic wealth and human development go hand in hand, since the countries with the highest HDIs also had the highest CO2 emissions, however the countries producing the highest emissions were not necessarily the most populous, indicating that population is not a significant contributor to either HDI or CO2 emissions.


# Introduction
The Human Development Index (HDI) is an indicator of a country’s level of development, expressed as a unitless average of three dimensions: health, education and income (Wolff et al., 2011). A country’s development index can be categorised as low (0.0 to 0.5), medium (0.5 to 0.8) and high (0.8 to 1.0).
The HDI can be used to demonstrate global inequality in wealth, living standards and even carbon emissions (Chancel & Piketty, 2015; Oxfam, 2015). Motivated by an interest in how carbon emissions can highlight the uneven distribution of wealth, this report aims to use global environmental data from 2014 (the most recent Gapminder data available) to test whether there is a difference between total CO2 emissions in high and low HDI countries, whether CO2 emissions per person
increase with HDI, and whether a country’s population can be used to its total CO2 emissions.

