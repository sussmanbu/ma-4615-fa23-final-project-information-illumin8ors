library(tidyverse)
library(readr)

print("Loading")
load('./dataset/NSDUH_2021.RData')
print("Done Loading")

## CLEAN the data
drug_health_data_clean <- PUF2021_100622
print("Done Cleaning")

write_csv(drug_health_data_clean, "./dataset/cleaned_data.csv")
print("Done Saving")


