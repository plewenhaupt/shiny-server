library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)
library(scales)
library(plotly)
library(lubridate)
library(zoo)
library(forecast)


BNPanvurl <- "http://api.scb.se/OV0104/v1/doris/sv/ssd/START/NR/NR0103/NR0103A/NR0103ENS2010T01Kv"

BNPanvrequestBody <- paste0('{
  "query": [
                          {
                          "code": "Anvandningstyp",
                          "selection": {
                          "filter": "item",
                          "values": [
                          "SUMANV"
                          ]
                          }
                          },
                          {
                          "code": "ContentsCode",
                          "selection": {
                          "filter": "item",
                          "values": [
                          "NR0103BV"
                          ]
                          }
                          }
                          ],
                          "response": {
                          "format": "px"
                          }
                          }')

BNPanvres <- httr::POST(url = BNPanvurl,
                  body = BNPanvrequestBody,
                  encode = "json")

BNPanvc <- content(BNPanvres)

BNPanvr <- rawToChar(BNPanvc)

BNPanvx <- read.table(text = BNPanvr, sep = "\n")
BNPanvx[1] <- as.character(BNPanvx[,1])

BNPanvy <- BNPanvx[grep("^TIMEVAL", BNPanvx[,1]),]
BNPanvYearQtr <- BNPanvy %>% strsplit(",") %>% unlist()
BNPanvYearQtr <- BNPanvYearQtr[-1]
BNPanvYearQtr[length(BNPanvYearQtr)] <- gsub(";", "", BNPanvYearQtr[length(BNPanvYearQtr)])
BNPanvYearQtr <- gsub("K", " Q", BNPanvYearQtr)
#DebtYearSplit <- strsplit(DebtYearMonth, split="-")
#DebtYearSplit <- as.data.frame(DebtYearSplit)
#DebtYearSplit <- as.data.frame(t(DebtYearSplit))

#DebtYearSplit$V1 <- as.numeric(as.character(DebtYearSplit$V1))
#DebtYearSplit$V2 <- as.numeric(as.character(DebtYearSplit$V2))

BNPanvDataRow <- which(BNPanvx[,1] %in% "DATA=")
BNPanvEndRow <- which(BNPanvx[,1] %in% ";")

#Data
BNPanve <- BNPanvx[BNPanvDataRow + 1,]
BNPanv <- BNPanve %>% strsplit(" ") %>% unlist() %>% as.numeric()

BNPanvdf <- as.data.frame(cbind(BNPanvYearQtr, BNPanv))
BNPanvdf$BNPanv <- as.numeric(as.character(BNPanvdf$BNPanv))
BNPanvdf$BNPanvYearQtr <- as.yearqtr(BNPanvdf$BNPanvYearQtr)

BNPanvCut <- BNPanvdf[121:152, ]

#Forecast
ts_BNPanvCut <- ts(BNPanvCut$BNPanv, start=2010, frequency=4)

