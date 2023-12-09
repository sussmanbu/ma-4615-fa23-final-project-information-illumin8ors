library(tidyverse)
library(readr)
library(readxl)
library(tidycensus)
suppressPackageStartupMessages(library(sf))
suppressPackageStartupMessages(library(tmap))
options(tigris_use_cache = TRUE)
census_api_key(c5c850588b50b20572e9b6df39c63b6923bcee30, overwrite = TRUE, install = TRUE)
library("stringr")     
install.packages("usmap")
library(usmap)
library(ggplot2)


# Read the CSV data file (make sure to provide the correct arguments)
load("./dataset/NSDUH_2021.RData")

## CLEAN the data
# Use select to filter columns by name and store the result in a new dataframe
drug_health_data_clean_new <- PUF2021_100622 |>
  select(QUESTID2, filedate,
         cigwilyr,cigtry,cigrec,CIG30AV, 
         alctry, alcrec, aldaypwk, ALCUS30D, AL30EST,
         mjage, mjrec, mrdaypwk, MJDAY30A, MR30EST,
         cocage, cocrec, ccdaypwk, CC30EST,
         crkage, crdaypwk, crakrec, CR30EST,
         herage, herrec, hrdaypwk, HR30EST,
         hallucage, hallucrec, halldypwk, HALLUC30E, lsdage, pcpage, ecstmoage,
         inhalage, inhalrec, inhdypwk, INHAL30ES,
         methamage, methamrec, methdypwk, METHAM30E,
         oxcnanyyr, oxcnnmage, fentanyyr, pnranyrec, PNRNM30ES, PNRNM30AL, pnrwygamt, pnrwygamt, pnrwyoftn, pnrwylngr,
         trqanylif, trqanyrec,
         stmanylif, stmanyrec,
         sedanylif, sedanyrec,
         iicigrc, II2CIGRC, iralcrc, II2ALCRC, iicrkrc, II2CRKRC,
         alcyrtot, cocyrtot, crkyrtot, heryrtot, hallucyfq, methamyfq,
         ircigfm, ircgrfm, IRSMKLSS30N, iralcfm, irmjfm, ircocfm, ircrkfm,
         cigflag, cigyr, cigmon, cgrflag, cgryr, cgrmon, pipflag, pipmon, smklssflag, smklssyr, smklssmon, tobflag, tobyr, tobmon,
         AD_MDEA1,AD_MDEA2, AD_MDEA3, AD_MDEA4,
         yther, yshsw, YUMHTELYR2,
         yowrslow, yowrdcsn, YO_MDEA1, YO_MDEA2, YO_MDEA3, YO_MDEA4, YO_MDEA5, YO_MDEA6, YO_MDEA7, YO_MDEA8, yopsrels, ymdelt,
         cadrpeop, casurcvr, camhprob, vapanyevr,
         irvapanyrec, CAMHPROB2, vaptypemon,
         udaltimeget, udaltrystop, udalstopact, udalwdsweat, udalavwsvtr,
         udmjtimeget, udmjlesseff, udmjnotstop, udmjwddeprs,
         udcctimeget, udccwantbad, udccstrurge, udccstopact,
         udhetimeuse, udhenotstop,udhehlthprb, udhestopact, udhatimeuse,
         booked, bkdrvinf,
         txevrrcvd, txyrprisn, txyrslfhp, txltpyhins,
         snysell, snyattak, snrldcsn, 
         yeatndyr, yehmslyr, yestscig,
         DSTNRV30, suiplanyr,
         irmedicr, irmcdchp, irchmpus, irchmpus, irprvhlt, irothhlt, irfamsoc, irfamssi, irfstamp, irfampmt, IRPINC3, IRFAMIN3,
         PDEN10, COUTYP4, MAIIN102, AIIND102, 
         ENRLCOLLFT2, wrkhadjob, sexident, milstat, NEWRACE2, income, POVERTY3, PDEN10, COUTYP4) |> 
  mutate(NEWRACE2 = recode(NEWRACE2, "1" = "NonHisp White", "2" = "NonHisp Black/Afr Am", "3" = "NonHisp Native Am/AK Native", "4" = "NonHisp Native HI/Other Pac Isl", "5" = "NonHisp Asian", "6" = "NonHisp more than one race", "7" = "Hispanic"))
  


# Save the cleaned data to a new CSV file
saveRDS(drug_health_data_clean_new, "./dataset/cleaned_data_new.rds")

getwd()

Census <- read_excel(path = "./dataset/co-est2019-alldata(1).xlsx", range = "A2:H3194", 
                     col_names = c("SUMLEV", "REGION", "DIVISION", "STATE", "COUNTY", "STNAME", "CITYNAME","CENSUS2010POP"), 
                     col_types = c("guess", "text", "text", "guess", "guess", "text", "text", "numeric"))


saveRDS(Census, "./dataset/Census_2010_data.rds")

CBSA <- read_excel(path = "./dataset/CBSAdata.xlsx", 
                   col_names = c("CBSA_Code", "Metro_Division_Code", "CSA_Code", "CBSA Title", 
                                 "Level_of_CBSA", "Status", "Metropolitan_Division_Title", 
                                 "CSA_Title", "Component_Name", "State", "FIPS", "County_Status"), 
                   col_types = c("guess", "guess", "guess", "text", "text", "guess", 
                                 "text", "text", "text", "text", "guess", "text"), skip = 4, na = c("missing", "NA"))

saveRDS(CBSA, "./dataset/CBSA_data_clean.rds")

RUCC <- read_excel(path = "./dataset/ruralurbancodes2013.xls",
                   col_names = c("FIPS", "State", "County_Name", "Population_2010",
                   "RUCC_2013", "Description"), 
                   col_types = c("guess", "text", "text", "numeric", "numeric", "text"),
                   skip = 1, na = c("missing", NA))

saveRDS(RUCC, "./dataset/RUCC_clean.rds")


#creating a merged data set with location information:

#(counties_areas_in_census <- Census |> distinct(CITYNAME, STNAME, .keep_all = TRUE) |> pull(CITYNAME, STNAME))

#CBSA_w_counties_only <- CBSA |> 
#filter(str_detect(Component_Name, "County") == TRUE)

county_overlap <- CBSA |>
  filter(Component_Name %in% counties_areas_in_census) |>
  pull(Component_Name)

pop_by_county <- Census |>
  distinct(CITYNAME) |>
  filter(CITYNAME %in% county_overlap)
  #now need to order alphabetically

# join Census |> distinct(CITYNAME, STNAME, .keep_all = TRUE) with CBSA data set

(Clean_census <- Census |> distinct(CITYNAME, STNAME, .keep_all = TRUE))

by <- join_by(CITYNAME == Component_Name, STNAME == State) 
merged <- inner_join(Clean_census, CBSA, by)

# Breakdown of the PDEN10 variable:

more_than_equalto_mil_CBSA <- merged |>
  filter(CENSUS2010POP >= 1000000)

mil_plus_CBSA_states <- more_than_equalto_mil_CBSA |>
  pull(STNAME)

mil_plus_CBSA_counties <- more_than_equalto_mil_CBSA |>
  pull(CITYNAME)

less_than_mil_CBSA <- merged |>
  filter(CENSUS2010POP < 1000000)

not_in_CBSA <- Clean_census |>
  filter(!CITYNAME %in% county_overlap) |>
  select(CITYNAME, CENSUS2010POP)

Census_counties <- Census |> filter(STNAME != CITYNAME) |> pull(CITYNAME)
census_pops <- Census |> filter(STNAME != CITYNAME) |> pull(CENSUS2010POP)

county_pop <- countypop |>
  filter(county %in% Census_counties)
  mutate("2010_pop" = census_pops)

plot_usmap(regions = "counties", ) + 
  labs(title = "U.S. counties") +
  theme(panel.background=element_blank())

# COUNTYP4 Breakdowns:

by <- join_by(CITYNAME == County_Name, FIPS == FIPS)
merged_all <- inner_join(merged, RUCC, by)

Large_metro_county <- merged_all |>
  filter(RUCC_2013 == 1)

Small_metro_county <- merged_all |>
  filter(RUCC_2013 %in% c(2, 3))

Non_metro_county <- merged_all |>
  filter(RUCC_2013 > 3) |>
  group_by(RUCC_2013) |>
  summary(pop_2013 = sum(Population_2010))

Large_metro_county |>
  ggplot(aes(x = CITYNAME, y = alcever)) + geom_point()

# from COUNTYP4: 1 = from large metro (25956), 2 = small metro (21883), 3 = nonmetro (10195)
















