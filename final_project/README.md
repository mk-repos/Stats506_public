This repository contains the scripts created for [Final Project, Statistics 506, Fall 2020](https://jbhender.github.io/Stats506/F20/FinalProject.html)

# Question of Interest

> Do adults in the U.S. with Medicaid use hospitals more often than those with private insurance?

# Files

## Report
 - `report.Rmd` is the write-up containing all results and descriptions.
 - `report.html` is the rendered `report.Rmd`

## Codes for Analysis
### Data Cleaning (in R)
 - `analysis_crean_data.R` cleans data, computes inverse-probability weights, and outputs datasets for analysis.
### Statistical Analysis (in STATA)
 - `analysis_ologit.do` creates a two-way table and applies ordinal logistic regression using survey weights.
 - `analysis_ipw` applies ordinal logistic regression using inverse-probability weights

## Data
 - Original and cleaned datasets are stored in `./data/`
 - The files whose names start with `result_` are the output of the STATA analysis results.