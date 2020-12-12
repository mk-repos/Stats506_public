*-----------------------------------------------------------------------------*
* Stats 506, Fall 2020 
* Final Project, Analysis
* 
* This script performs an ordinal logistic regression using inverse propencity
* score computed in R. It outputs resulting tables in .dta.
* 
* `regsave` module (Julian Reif, 2008) was used to save the results in .dta.
* 
* Author: Moeki Kurita
*-----------------------------------------------------------------------------*
// 79: ---------------------------------------------------------------------- *

// set up: ------------------------------------------------------------------ *
version 16.1
log using analysis_ipw.log, text replace

// additional packages: ----------------------------------------------------- *
* net install regsave, ///
* from("https://raw.githubusercontent.com/reifjulian/regsave/master") replace  

// Propencity score: -------------------------------------------------------- *
use "./data/ipw.dta", clear

svyset, clear
svyset [pweight=boosted]
svydes

// Ordinal Logistic Regression with Propencity Score: ----------------------- *
* see if insurance status is significant alone
svy: ologit hospital i.treatment  

* request odds ratio
svy: ologit, or

* export results (in logit)
regsave using "./data/result_ipw", replace tstat pval ci

// close log: --------------------------------------------------------------- *
log close

// 79: ---------------------------------------------------------------------- *
