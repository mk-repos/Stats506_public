## R Script for Final Project, Stats 506, F20
##
## This script cleans and formats the data of NHANES 2017-2018, and outputs
## a cleaned dataset and also generate a dataset with a column of 
## inverse probability weights computed by ADA boosting.
##
## A portion of the code for ADA boosting is a modified version of a class note
## of Stats 504, F20
## ("Causal Inference" by Dr. Mesner, https://rpubs.com/omesner/causal)
##
## Author(s): Moeki Kurita, mkurita@umich.edu
# 79: -------------------------------------------------------------------------

# Libraries: ------------------------------------------------------------------
library(haven); library(twang); library(tidyverse)

# Data loader: ----------------------------------------------------------------
demo_2018 = read_xpt("./data/DEMO_J.XPT")
insurance_2018 = read_xpt("./data/HIQ_J.XPT")
hospital_2018 = read_xpt("./data/HUQ_J.XPT")

demo_2018 = demo_2018 %>% 
  select(id = SEQN,
         exam_status = RIDSTATR, # some variable (pregnancy) only available
         # among those MEC examined
         gender = RIAGENDR,
         age = RIDAGEYR,
         race = RIDRETH1,
         pregnancy = RIDEXPRG, # pregnancy at the time of the exam
         education = DMDEDUC2, # only focus on adults (20+)
         fm_income = INDFMIN2,  # family income
         psu = SDMVPSU,
         strata = SDMVSTRA,
         weight = WTINT2YR,
         weight_mec = WTMEC2YR)

insurance_2018 = insurance_2018 %>% 
  select(id = SEQN,
         insurance = HIQ011, # covered by any health insurance
         insurance_past = HIQ210, # no insurance last year
         private = HIQ031A,
         medicaid = HIQ031D,
         chip = HIQ031E,
         state = HIQ031H, #  covered by state-sponsored health plan
         other_gov = HIQ031I, # covered by other government insurance
         medicare = HIQ031B,
         military = HIQ031F
  )

hospital_2018 = hospital_2018 %>% 
  select(id = SEQN,
         health = HUQ010, # general health condition
         hospital = HUQ051) # times receive healthcare over past year

# Clean demographic data: -----------------------------------------------------
demo_2018 = demo_2018 %>% 
  filter(age >= 20 & age < 65) %>% # exclude children and elderly
  mutate(agec = age - mean(age),
         female = ifelse(gender == 2, 1, 0),
         race = factor(race, c(1,2,3,4,5), c("Mexican", "Hispanic", "White",
                                             "Black", "Other")),
         college = factor(ifelse(education == 4 | education == 5, 1, 0)),
         fm_income = ifelse(fm_income == 12 | fm_income == 13
                            | fm_income == 77 | fm_income == 99,
                            NA, fm_income),
         # Low = $0-$24,999,  Mid = $25,000-54,999, High = $55,000 & over
         fm_income_shorten = ifelse(fm_income == 1 | fm_income == 2
                                    | fm_income == 3 | fm_income == 4
                                    | fm_income == 5, 1,
                             ifelse(fm_income == 6 | fm_income == 7
                                    | fm_income == 8, 2,
                             ifelse(fm_income == 9 | fm_income == 10
                                    | fm_income == 14 | fm_income == 15, 3, 
                                    fm_income))),
         fm_income_shorten = factor(fm_income_shorten, c(1, 2, 3),
                                    c("Low", "Mid", "High"))) %>% 
  select(-gender, -education)

# Clean & merge insurance data: -----------------------------------------------
## drop cases we don't use
df = demo_2018 %>% 
  left_join(insurance_2018, by = c("id")) %>% 
  filter(insurance == 1) %>%  # exclude individuals without any insurance
  filter(insurance_past != 1) %>% # exclude individuals who didn't have
  # insurance in the previous year
  filter(is.na(military)) %>% # exclude military person
  filter(is.na(medicare)) # excludes disabled people under 64 with Medicare 

## rename & define columns
df = df %>% 
  mutate(insurance = factor(ifelse(insurance == 7 | insurance == 9, NA,
                                   ifelse(insurance == 1, 1, 0))),
         private = factor(ifelse(private == 77 | private == 99, NA, private )),
         medicaid = factor(medicaid),
         chip = factor(chip),
         state = factor(state),
         other_gov = factor(other_gov),
         military = factor(military),
         subsidized = factor(ifelse(!is.na(medicaid) | !is.na(chip) 
                                    | !is.na(state) | !is.na(other_gov),
                                    1, 0)) ) %>% 
  # create new variable indicating whether subsidized or 100% private
  mutate(indicator = factor(ifelse(!is.na(private) & subsidized == 0,
                                   1, ifelse(subsidized == 1, 2, NA)),
                            c(1, 2), c("private", "subsidized")) ) %>% 
  # there are no observations left in the following category
  select(-medicare, -chip, -military)

## recode categorical variables to 0-1 dammies
df = df %>% 
  mutate_at(c("private", "medicaid", "state", "other_gov"),
            funs(ifelse(is.na(.),0,.)))

## drop NA cases on the new indicator variable
df = df %>%
  drop_na(indicator)

# Clean & merge hospital data: ------------------------------------------------
df = df %>% 
  left_join(hospital_2018, by = c("id")) %>% 
  mutate(health = ifelse(health == 7 | health == 9, NA, health),
         hospital = ifelse(hospital == 77 | hospital == 99, NA, hospital))

## drop NA cases on the variable of interest
df = df %>% 
  drop_na(health, hospital)

# Output cleaned dataset: -----------------------------------------------------
write_dta(df, "./data/cleaned.dta")

# Compute inverse-probability weights: ----------------------------------------

## recode indicator variable to 0-1
## 1 indicates the subject receive medicaid. state/government assistance
df = df %>% 
  mutate(treatment = ifelse(indicator == "subsidized", 1, 0))

## dataframe for IPW
df_dropped = df %>% 
  select(hospital, treatment, agec, female, race, college, health, fm_income)

## ADA boosting
boosted.mod <- twang::ps(treatment ~ agec + female + race + college + health
                         + fm_income,
                         data=as.data.frame(df_dropped),
                         estimand = "ATE",
                         n.trees = 5000, 
                         interaction.depth=2, 
                         perm.test.iters=0, 
                         verbose=FALSE, 
                         stop.method = c("es.mean"))

## append resulting weights
df_dropped$boosted <- get.weights(boosted.mod)

## Check absolute standard difference. Confirming all < 0.2.
plot(boosted.mod, plots=3)

# Output dataset with inverse-probability weights: ----------------------------
write_dta(df_dropped, "./data/ipw.dta")

# 79: -------------------------------------------------------------------------
