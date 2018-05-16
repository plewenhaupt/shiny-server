library(jsonlite)
library(dplyr)
library(httr)

MeanAgeurl <- "http://api.scb.se/OV0104/v1/doris/sv/ssd/START/BE/BE0101/BE0101B/BefolkMedianAlder"

MeanAgerequestBody <- paste0('{
                          "query": [
                         {
                         "code": "Kon",
                         "selection": {
                         "filter": "item",
                         "values": [
                         "1",
                         "2",
                         "1+2"
                         ]
                         }
                         },
                         {
                         "code": "ContentsCode",
                         "selection": {
                         "filter": "item",
                         "values": [
                         "000000MD"
                         ]
                         }
                         }
                         ],
                         "response": {
                         "format": "px"
                         }
                         }')

MeanAgeres <- httr::POST(url = MeanAgeurl,
                     body = MeanAgerequestBody,
                     encode = "json")

MeanAgec <- content(MeanAgeres)

MeanAger <- rawToChar(MeanAgec)

MeanAgex <- read.table(text = MeanAger, sep = "\n")
MeanAgex[1] <- as.character(MeanAgex[,1])

MeanAgey <- MeanAgex[grep("^TIMEVAL", MeanAgex[,1]),]
MeanAgeYear <- MeanAgey %>% strsplit(",") %>% unlist()
MeanAgeYear <- MeanAgeYear[-1]
MeanAgeYear[length(MeanAgeYear)] <- gsub(";", "", MeanAgeYear[length(MeanAgeYear)])
MeanAgeYear <- as.numeric(MeanAgeYear)

maxMeanAgeYear <- max(MeanAgeYear)
minMeanAgeYear <- min(MeanAgeYear)


MeanAgeDataRow <- which(MeanAgex[,1] %in% "DATA=")
#Male data
MeanAgem <- MeanAgex[MeanAgeDataRow + 1,]
MeanAgeMen <- MeanAgem %>% strsplit(" ") %>% unlist() %>% as.numeric()

#female data
MeanAgef <- MeanAgex[MeanAgeDataRow + 2,]
MeanAgeWomen <- MeanAgef %>% strsplit(" ") %>% unlist() %>% as.numeric()

#Total data 
MeanAget <- MeanAgex[MeanAgeDataRow + 3,]
MeanAgeTotal <- MeanAget %>% strsplit(" ") %>% unlist() %>% as.numeric()

MeanAgedf <- as_tibble(cbind(MeanAgeYear, MeanAgeMen, MeanAgeWomen, MeanAgeTotal))
colnames(MeanAgedf) <- c("Year", "Men", "Women", "Total")