This repository contains the scripts created for [Final Project, Statistics 506, Fall 2020](https://jbhender.github.io/Stats506/F20/FinalProject.html)

# Question of Interest

> Do adults in the U.S. subsidized by Medicaid use health care services more often than those with private insurance?

# Analysis

***Work in progress***

The `.Rmd` code contains a draft of the explanations & descriptions that will be used in the final report. The final report is going to be a two-page document summarizing the contents of this `.Rmd`.

 - `analysis.html` is the rendered .Rmd.
 - `analysis.Rmd` cleans NHANES 2017-2018 data for R/STATA, shows resulting tables from the STATA code below, applies inverse probability weighting
 - `analysis.do` by using the cleaned dataset & survey weights, creates two-way table, applies ordinal logistic regression, output resulting tables in `./data/`

# To-do Lists

 - Document the more detailed interpretation of the results of the analysis. 
 - Using NHANES data from the previous wave, extract only those whose insurance status is the same in 2015-2016 and 2017-2018. Repeat all analyses.
 - Consider the interaction of variables, and search for a better model.