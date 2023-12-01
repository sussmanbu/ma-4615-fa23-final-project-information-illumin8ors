library(tidyverse)
library(readr)
library(readxl)

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


Census <- read_excel(path = "./dataset/Census2010_2019data.xlsx", range = "A3:H3194", 
col_names = c("SUMLEV", "REGION", "DIVISION", "STATE", "COUNTY", "STNAME", "CITYNAME",
"CENSUS2010POP"), col_types = c("guess", "text", "text", "guess", 
                                "guess", "text", "text", "numeric"))

saveRDS(Census, "./dataset/Census_2010_data.rds")
getwd()


