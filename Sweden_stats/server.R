options(shiny.sanitize.errors = FALSE)
library(shiny)
library(ggplot2)
library(plotly)

source('datapull.R')

shinyServer(function(input, output) {

  start <- reactive({input$slider1[1]})
  end <- reactive({input$slider1[2]})
  
  
  pop <- reactive({
    subset(populationdf, Year >= start() & Year <= end())
  })
   
  output$plot <- renderPlotly({
    ggplotly(ggplot(pop(), aes(x=Year)) 
    + geom_line(aes(y=Men, group=1), color="blue") 
    + geom_line(aes(y=Women, group=1), color="red") 
    + geom_line(aes(y=Total, group=1), color="green") 
    + scale_y_continuous(labels = comma) 
    + theme(axis.title.y=element_blank(), axis.text.y=element_text(size = 7), plot.margin = margin(10, 10, 20, 25)) 
    + ggtitle(label=paste("Sveriges befolkning ", as.character(minYear), " - ", as.character(maxYear), sep="")))
  })
  
})
