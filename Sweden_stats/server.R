library(shiny)
library(httr)
library(jsonlite)
library(dplyr)
library(data.table)
library(ggplot2)
library(scales)
library(plotly)
library(lubridate)




shinyServer(function(input, output) {
  url <- "http://api.scb.se/OV0104/v1/doris/sv/ssd/START/BE/BE0101/BE0101A/BefolkningR1860"
  
  requestBody <- paste0('{"query":[{"code":"Kon","selection":{"filter":"item","values":["1", "2"]}}],"response": {"format": "px"}}')
  
  res <- httr::POST(url = url,
                    body = requestBody,
                    encode = "json")
  
  c <- content(res)
  
  r <- rawToChar(c)
  
  x <- read.table(text = r, sep = "\n")
  x[1] <- as.character(x[,1])
  
  y <- x[grep("^TIMEVAL", x[,1]),]
  Year <- y %>% strsplit(",") %>% unlist()
  Year <- Year[-1]
  Year[length(Year)] <- gsub(";", "", Year[length(Year)])
  Year <- as.numeric(Year)
  
  
  DataRow <- which(x[,1] %in% "DATA=")
  #Male data
  m <- x[DataRow + 1,]
  Men <- m %>% strsplit(" ") %>% unlist() %>% as.numeric()
  
  #female data
  f <- x[DataRow + 2,]
  Women <- f %>% strsplit(" ") %>% unlist() %>% as.numeric()
  
  populationdf <- as.data.frame(cbind(Year, Men, Women))
  populationdf$Total <- populationdf$Men + populationdf$Women
   
  output$popPlot <- renderPlotly({
    popPlot <- ggplot(populationdf, aes(x=Year)) 
    popPlot <- popPlot + geom_line(aes(y=Men, group=1), color="blue")
    popPlot <- popPlot + geom_line(aes(y=Women, group=1), color="red")
    popPlot <- popPlot + geom_line(aes(y=Total, group=1), color="green")
    popPlot <- popPlot + scale_y_continuous(labels = comma)
    popPlot <- popPlot + theme(axis.title.y=element_blank(), axis.text.y=element_text(size = 7), plot.margin = margin(10, 10, 20, 25))
    popPlot <- ggplotly(popPlot, tooltip = c("y", "x"))
    print(popPlot)
  })
  
})
