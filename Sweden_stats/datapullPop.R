library(jsonlite)
library(dplyr)
library(httr)

Popurl <- "http://api.scb.se/OV0104/v1/doris/sv/ssd/START/BE/BE0101/BE0101A/BefolkningR1860"

PoprequestBody <- paste0('{"query":[{"code":"Kon","selection":{"filter":"item","values":["1", "2"]}}],"response": {"format": "px"}}')

Popres <- httr::POST(url = Popurl,
                  body = PoprequestBody,
                  encode = "json")

Popc <- content(Popres)

Popr <- rawToChar(Popc)

Popx <- read.table(text = Popr, sep = "\n")
Popx[1] <- as.character(Popx[,1])

Popy <- Popx[grep("^TIMEVAL", Popx[,1]),]
PopYear <- Popy %>% strsplit(",") %>% unlist()
PopYear <- PopYear[-1]
PopYear[length(PopYear)] <- gsub(";", "", PopYear[length(PopYear)])
PopYear <- as.numeric(PopYear)

maxPopYear <- max(PopYear)
minPopYear <- min(PopYear)


PopDataRow <- which(Popx[,1] %in% "DATA=")
#Male data
Popm <- Popx[PopDataRow + 1,]
PopMen <- Popm %>% strsplit(" ") %>% unlist() %>% as.numeric()

#female data
Popf <- Popx[PopDataRow + 2,]
PopWomen <- Popf %>% strsplit(" ") %>% unlist() %>% as.numeric()

populationdf <- as.data.frame(cbind(PopYear, PopMen, PopWomen))
colnames(populationdf) <- c("Year", "Men", "Women")
populationdf$Total <- populationdf$Men + populationdf$Women