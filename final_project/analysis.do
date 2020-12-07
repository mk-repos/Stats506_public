*-----------------------------------------------------------------------------*
* Stats 506, Fall 2020 
* Final Project, Analysis
* 
*
* Author: Moeki Kurita
*-----------------------------------------------------------------------------*
// 79: ---------------------------------------------------------------------- *

// set up: ------------------------------------------------------------------ *
version 16.1
* log using analysis.log, text replace

use "./data/cleaned.dta", clear

// additional packages: ----------------------------------------------------- *
* net install regsave, ///
* from("https://raw.githubusercontent.com/reifjulian/regsave/master") replace  

// survey design: ----------------------------------------------------------- *
svyset, clear
svyset psu [pweight=weight], strata(strata)
svydes

// (3) Test for Association with Survey Design: ----------------------------- *
svy: tab insurance_cln, se ci col deff
svy: tab hospital, se ci col deff

* test of association
svy: tabulate hospital insurance_cln, missing percent column

* export results
estpost svy: tabulate hospital insurance_cln, missing percent column
esttab .  using "./data/stata_tabulate.csv", replace wide b se ///
scalars(F_Pear p_Pear) plain nostar unstack mtitle(`e(colvar)')

// (4) Ordinal Logistic Regression with Survey Design: ---------------------- *
* see if insurance status is significant alone
svy: ologit hospital i.insurance_cln  

* control by all available variables
svy: ologit hospital i.insurance_cln c.agec i.female i.race i.college ///
i.health i.fm_income_shorten

* export results
regsave using "./data/stata_ologit", replace tstat pval 

* adjusted wald test
test 2.insurance_cln /* significant */
test agec /* significant */
test 1.female /* significant */
test 2.race 3.race 4.race 5.race /* significant */
test 2.college /* significant */
test 2.fm_income_shorten 3.fm_income_shorten
