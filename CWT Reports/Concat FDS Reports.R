


library(tidyverse)
## First the working directory is set to where you have saved the provider level reports which 
## it then creates a list of CSV files within that folder
## I then removes the exception files from that list
setwd("C:/Users/DEGAN001/Documents/CWT nhs digital/E56000020 PROVIDERS")
templist <- list.files(pattern = ".CSV", recursive = TRUE)
files <- templist[!str_detect(templist,pattern = "EXCEPTIONS")]

## crete look up for trusts to bu used for joins 
Organisation.Code <- c("R1H","RAL","RAN","RAP","RF4","RKE","RP4","RP6","RQW","RQX","RRV")
trustname <- c("BARTS HEALTH NHS TRUST","ROYAL FREE LONDON NHS FOUNDATION TRUST","ROYAL NATIONAL ORTHOPAEDIC HOSPITAL NHS TRUST",
               "NORTH MIDDLESEX UNIVERSITY HOSPITAL NHS TRUST","BARKING, HAVERING AND REDBRIDGE UNIVERSITY HOSPITALS NHS TRUST",
               "THE WHITTINGTON HOSPITAL NHS TRUST","GREAT ORMOND STREET HOSPITAL FOR CHILDREN NHS FOUNDATION TRUST",
               "MOORFIELDS EYE HOSPITAL NHS FOUNDATION TRUST","THE PRINCESS ALEXANDRA HOSPITAL NHS TRUST",
               "HOMERTON UNIVERSITY HOSPITAL NHS FOUNDATION TRUST","UNIVERSITY COLLEGE LONDON HOSPITALS NHS FOUNDATION TRUST")
trustsector <- c("NEL","NCL","NCL","NCL","NEL","NCL","NCL","NCL","ESSEX","NEL","NCL")

trustlookup <- data.frame(Organisation.Code,trustname,trustsector,stringsAsFactors = FALSE)
## Create empty table
temp <- read.csv(files[1],header = TRUE,sep = ",")
temp$trustname <- "temp"
temp$trustsector <- "temp"
temp$Breaches <- "temp"
cosdstruct <- temp[0,]

write.table(cosdstruct,"FDSNHSData.csv",sep = ",",quote = TRUE,row.names = FALSE)

## save files to empty to table

for (i in 1:length(files)) {
FDStemp <-  read.csv(files[i], header = TRUE,sep = ",")
FDStemp <-  FDStemp %>% 
            filter(FDStemp$Source.Of.Referral != "Totals")

FDStemp <- left_join(FDStemp,trustlookup, by ="Organisation.Code" )

FDStemp$trustname[is.na(FDStemp$trustname)] <- "Other"
FDStemp$trustsector[is.na(FDStemp$trustsector)] <- "Other"

FDStemp$Breach <-  FDStemp$Days.29.To.38 + FDStemp$Days.39.To.62 + FDStemp$Days.63.And.More

write.table(FDStemp,"FDSNHSData.csv",sep = ",",row.names = FALSE, col.names = FALSE, append = TRUE)
  
}

setwd("C:/Users/DEGAN001/Documents")
