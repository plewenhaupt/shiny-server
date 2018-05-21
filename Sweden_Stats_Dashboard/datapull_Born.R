library(jsonlite)
library(dplyr)
library(httr)

Bornurl <- "http://api.scb.se/OV0104/v1/doris/sv/ssd/START/BE/BE0101/BE0101H/FoddaK"

BornrequestBody <- paste0('{
  "query": [
                          {
                          "code": "Region",
                          "selection": {
                          "filter": "vs:RegionRiket99",
                          "values": [
                          "00"
                          ]
                          }
                          },
                          {
                          "code": "Kon",
                          "selection": {
                          "filter": "item",
                          "values": [
                          "1",
                          "2"
                          ]
                          }
                          }
                          ],
                          "response": {
                          "format": "px"
                          }
                          }')

Bornres <- httr::POST(url = Bornurl,
                      body = BornrequestBody,
                      encode = "json")

Bornc <- content(Bornres)

Bornr <- rawToChar(Bornc)

Bornx <- read.table(text = Bornr, sep = "\n")
Bornx[1] <- as.character(Bornx[,1])

Borny <- Bornx[grep("^TIMEVAL", Bornx[,1]),]
BornYear <- Borny %>% strsplit(",") %>% unlist()
BornYear <- BornYear[-1]
BornYear[length(BornYear)] <- gsub(";", "", BornYear[length(BornYear)])
BornYear <- as.numeric(BornYear)

maxBornYear <- max(BornYear)
minBornYear <- min(BornYear)


BornDataRow <- which(Bornx[,1] %in% "DATA=")
#Male data
Bornm <- Bornx[BornDataRow + 1,]
BornMen <- Bornm %>% strsplit(" ") %>% unlist() %>% as.numeric()

#female data
Bornf <- Bornx[BornDataRow + 2,]
BornWomen <- Bornf %>% strsplit(" ") %>% unlist() %>% as.numeric()

Borndf <- as_tibble(cbind(BornYear, BornMen, BornWomen))
colnames(Borndf) <- c("Year", "Births_Men", "Births_Women")
Borndf$Births_Total <- Borndf$Births_Men + Borndf$Births_Women

yoy <- 0
yoy <- append(yoy, diff(Borndf$Births_Total))
Borndf$Births_Relative_Growth <- yoy