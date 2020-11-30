# Primary Question

```
Do adults in the U.S. subsidized by Medicaid use health care services more often than those with private insurance?
```

Medicaid is a form of public assistance in which the government pays for insurance premiums, co-payments, prescription drugs, and medical expenses for low-income people. A typical criticism of such a health care system is the suspicion that the insured's health care utilization behavior (e.g., frequency) will be altered by the fact that it is free and that health care services will be excessively overused. Using data on the type of insurance and frequency of use of medical services available in NHANES, we will analyze whether there is any evidence to support this claim.

This kind of analysis is not possible in countries with universal health care systems, such as Japan and the United Kingdom. The question in a more general sense is whether the form of health insurance will cause any changes in people's behaviors in using health care providers. 

# Data

In the NHANES questionnaire survey, we will use the following:

 - Health Insurance (HIQ)
	 - This questionnaire allows us to obtain the type of insurance that subjects enroll in.
 - Hospital Utilization & Access to Care (HUQ)
	 - "*Number of times the subject receive healthcare over past year* (HUQ051)"

We will link the type of insurance **at the time of the survey** to the frequency of use **during the previous year**. Because the subjects may not have used their current insurance during the previous year, the following data/variable may be used to clean up the data as much as possible.

 - Insurance Questionnaire (HIQ) of the previous wave.
 - "*Time when no insurance in past year?* (HIQ210)"

# Analysis

We first calculate point estimates and confidence intervals of the frequency of hospital utilization by insurance type.

However, this doesn't take into account the fact that pregnant women and the elderly are more likely to use medical services, and that the health of the impoverished people may be poor in the first place compared to the rich people.

Thus, we also perform regression analysis and inverse-probability weighting, controlling for demographic attributes such as income and age, as well as information related to health care, such as pregnancy, that can be obtained from NHANES.

# Software

 - R, R studio
 - `twang` package for calculating propensity score and inverse weighting
