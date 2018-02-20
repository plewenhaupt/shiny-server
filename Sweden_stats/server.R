library(shiny)
library(ggplot2)
library(scales)
library(plotly)




shinyServer(function(input, output) {
  load("populationdf.Rdata")
   
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
