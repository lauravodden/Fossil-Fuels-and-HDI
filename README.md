# Fossil-Fuels-and-HDI: Carbon emissions as an indicator of human human standards of living.
Laura Vodden


## Executive Summary
> Carbon dioxide (CO2) emissions are produced by burning fossil fuels, primarily as a source of energy (Olivier et al., 2012). It has been demonstrated that countries with the highest CO2 emissions have the wealthiest people and greates economic growth (Hickel, 2020; Holtz-Eakin & Selden, 1995; Jorgenson et al., 2017), and that there is global inequality in the production of carbon emissions, reflecting this (Chancel & Piketty, 2015; Oxfam, 2015).

> While the wealth of a country is often expressed in terms of economic value, this is not the only measure of a country’s wealth (Hickel, 2020). The Human Development Index (HDI) is a measure of average human wellbeing in terms of health (measured by life expectancy), education (measured by mean years of schooling) and standard of living (measured by gross national income per capita). The HDI is the mean of the normalized indices for each of the three dimensions (UNDP, 2020).
This report aims to investigate the possibility that economic growth and human wellbeing go hand in hand, by comparing CO2 emissions with HDI and population data. To this end, the report will test:

> * 1. Whether there is a difference between total CO2 emissions in high and low HDI countries;
> * 2. Whether CO2 emissions per person increase with HDI; and
> * 3. Whether a country’s population can be used to its total CO2 emissions.

> In order to conduct this investigation, data was cleaned and analysed in RStudio, using the following methods to answer these three questions, respectively:

> * 1. A two-sample Wilcoxon test
> * 2. A two-sample T-test
> * 3. A linear regression analysis

> The report finds that there is a difference between CO2 emissions in high and low HDI countries, CO2 emissions do generally increase with HDI, and that population is not a good predictor for CO2 emissions and therefore HDI.

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
    
Finally, it must be noted that data available are not a random sample. The data include a population of all countries for which Gapminder data are available. In order to satisfy the requirements for any significance test, and to try to avoid any bias inherent in the original population data, a random sample of 100 countries was generated, using the <b>sample()</b> function. A selection of the resulting dataframe is shown in Table 1. Each of the three objectives covered in this report will refer to this random sample. <i>Table 2</i> provides further detail about the variables used. The full dataframe can be viewed in <i>Appendix 1</i>.
