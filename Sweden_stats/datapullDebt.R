library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)
library(scales)
library(plotly)
library(lubridate)


Debturl <- "http://api.scb.se/OV0104/v1/doris/sv/ssd/START/OE/OE0202/Statsskuld"

DebtrequestBody <- paste0('{
                      "query": [
                      {
                      "code": "Kontopost",
                      "selection": {
                      "filter": "item",
                      "values": [
                      "RG200"
                      ]
                      }
                      }
                      ],
                      "response": {
                      "format": "px"
                      }
                      }')

Debtres <- httr::POST(url = Debturl,
                  body = DebtrequestBody,
                  encode = "json")

Debtc <- content(Debtres)

Debtr <- rawToChar(Debtc)

Debtx <- read.table(text = Debtr, sep = "\n")
Debtx[1] <- as.character(Debtx[,1])

Debty <- Debtx[grep("^TIMEVAL", Debtx[,1]),]
DebtYearMonth <- Debty %>% strsplit(",") %>% unlist()
DebtYearMonth <- DebtYearMonth[-1]
DebtYearMonth[length(DebtYearMonth)] <- gsub(";", "", DebtYearMonth[length(DebtYearMonth)])
DebtYearMonth <- gsub("M", "-", DebtYearMonth)
#DebtYearSplit <- strsplit(DebtYearMonth, split="-")
#DebtYearSplit <- as.data.frame(DebtYearSplit)
#DebtYearSplit <- as.data.frame(t(DebtYearSplit))

#DebtYearSplit$V1 <- as.numeric(as.character(DebtYearSplit$V1))
#DebtYearSplit$V2 <- as.numeric(as.character(DebtYearSplit$V2))

DebtDataRow <- which(Debtx[,1] %in% "DATA=")
DebtEndRow <- which(Debtx[,1] %in% ";")

#Data
Debte <- Debtx[DebtDataRow + 1,]
Debt <- Debte %>% strsplit(" ") %>% unlist() %>% as.numeric()

NatDebtdf <- as.data.frame(cbind(DebtYearMonth, Debt))
#NatDebtdf <- bind_cols(NatDebtdf, DebtYearSplit)
NatDebtdf$Datum <- parse_date_time(NatDebtdf$DebtYearMonth, "%Y-%m")
NatDebtdf$Debt <- as.numeric(as.character(NatDebtdf$Debt))
#colnames(NatDebtdf)[c(3, 4)] <- c("Year", "Month")


maxDebtDate <- max(NatDebtdf$Datum)
minDebtDate <- min(NatDebtdf$Datum)