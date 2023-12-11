library(tidyverse)
library(readr)
  

drug_health_data2 <- PUF2021_100622 %>%
  select(cigever, mjever, alcever, cocever, income, NEWRACE2) %>%
  mutate(across(c(cigever, mjever, alcever, cocever), ~if_else(. == 1, 1, 0))) %>%
  mutate(NEWRACE2 = recode(NEWRACE2, 
                           `1` = "NonHisp White", 
                           `2` = "NonHisp Black/Afr Am", 
                           `3` = "NonHisp Native Am/AK Native", 
                           `4` = "NonHisp Native HI/Other Pac Isl", 
                           `5` = "NonHisp Asian", 
                           `6` = "NonHisp more than one race", 
                           `7` = "Hispanic"),
         any_drug_use = if_else(cigever == 1 | mjever == 1 | alcever == 1 | cocever == 1, 1, 0),
         income = as.factor(income),
         NEWRACE2 = as.factor(NEWRACE2))

logistic_model <- glm(any_drug_use ~ income + NEWRACE2, data = drug_health_data2, family = binomial)
logistic_model
logistic_model_interaction <- glm(any_drug_use ~ income * NEWRACE2, data = drug_health_data2, family = binomial)
summary(logistic_model_interaction)



# Since the drug use is  binary outcomes 1 or 2, I will use logistic regression as 
# the primary statistical model to explore the relationship between drug use and 
# income, alongside racial background. allows for the inclusion of interaction terms 
# to examine how the effect of one predictor varies across levels of another. 
# The null deviance (from 65,641 to 63,947) indicates that the predictors (income, race, 
# and interaction) contribute significantly to explaining the variability in drug use.
# the degrees of freedom (58,006 residual vs. 58,033 null) show that the model is quite complex.
# result: shows a complex interaction between income, race, and the likelihood of drug use. 
# Higher income generally showed an increased likelihood of drug use, yet this association was not 
# uniform across all racial categories.