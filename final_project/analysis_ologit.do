*-----------------------------------------------------------------------------*
* Stats 506, Fall 2020 
* Final Project, Analysis
* 
* This script performs a test of association and an ordinal logistic regression
* using NHANES data cleaned in R. It outputs resulting tables in .csv and .dta.
* 
* `regsave` module (Julian Reif, 2008) was used to save the results in .dta.
* 
* Author: Moeki Kurita
*-----------------------------------------------------------------------------*
// 79: ---------------------------------------------------------------------- *

// set up: ------------------------------------------------------------------ *
version 16.1

log using analysis_ologit.log, text replace

use "./data/cleaned.dta", clear

// additional packages: ----------------------------------------------------- *
* net install regsave, ///
* from("https://raw.githubusercontent.com/reifjulian/regsave/master") replace  

// survey design: ----------------------------------------------------------- *
svyset, clear
svyset psu [pweight=weight], strata(strata)
svydes

// Test for Association with Survey Design: --------------------------------- *
svy: tab indicator, se ci col deff
svy: tab hospital, se ci col deff

* test of association
svy: tabulate hospital indicator, missing percent column

* export results
estpost svy: tabulate hospital indicator, missing percent column
esttab .  using "./data/result_tabulate.csv", replace wide b ci ///
scalars(F_Pear p_Pear) plain nostar unstack mtitle(`e(colvar)')

// Ordinal Logistic Regression with Survey Design: -------------------------- *
* see if insurance status is significant alone
svy: ologit hospital i.indicator  

* control by all available variables
svy: ologit hospital i.indicator c.agec##c.agec i.female i.race i.college ///
i.health i.fm_income_shorten

* request odds ratio
svy: ologit, or

* export results (in logit)
regsave using "./data/result_ologit", replace tstat pval ci

* adjusted wald test
test 2.indicator
test agec /* significant */
test c.agec#c.agec
test 1.female /* significant */
test 2.race 3.race 4.race 5.race /* significant */
test 2.college /* significant */
test 2.fm_income_shorten 3.fm_income_shorten

// close log: --------------------------------------------------------------- *
log close

// 79: ---------------------------------------------------------------------- *
