library(jsonlite)
library(dplyr)
library(httr)

Deadurl <- "http://api.scb.se/OV0104/v1/doris/sv/ssd/START/BE/BE0101/BE0101I/DodaHandelseK"

DeadrequestBody <- paste0('{
  "query": [
                          {
                          "code": "Region",
                          "selection": {
                          "filter": "vs:RegionRiket99",
                          "values": []
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

Deadres <- httr::POST(url = Deadurl,
                     body = DeadrequestBody,
                     encode = "json")

Deadc <- content(Deadres)

Deadr <- rawToChar(Deadc)

Deadx <- read.table(text = Deadr, sep = "\n")
Deadx[1] <- as.character(Deadx[,1])

Deady <- Deadx[grep("^TIMEVAL", Deadx[,1]),]
DeadYear <- Deady %>% strsplit(",") %>% unlist()
DeadYear <- DeadYear[-1]
DeadYear[length(DeadYear)] <- gsub(";", "", DeadYear[length(DeadYear)])
DeadYear <- as.numeric(DeadYear)

maxDeadYear <- max(DeadYear)
minDeadYear <- min(DeadYear)


DeadDataRow <- which(Deadx[,1] %in% "DATA=")
#Male data
Deadm <- Deadx[DeadDataRow + 1,]
DeadMen <- Deadm %>% strsplit(" ") %>% unlist() %>% as.numeric()

#female data
Deadf <- Deadx[DeadDataRow + 2,]
DeadWomen <- Deadf %>% strsplit(" ") %>% unlist() %>% as.numeric()

Deaddf <- as_tibble(cbind(DeadYear, DeadMen, DeadWomen))
colnames(Deaddf) <- c("Year", "Deaths_Men", "Deaths_Women")
Deaddf$Deaths_Total <- Deaddf$Deaths_Men + Deaddf$Deaths_Women

yoy <- 0
yoy <- append(yoy, diff(Deaddf$Deaths_Total))
Deaddf$Deaths_Relative_Growth <- yoy