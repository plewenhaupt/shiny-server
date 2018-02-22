options(shiny.sanitize.errors = FALSE)
library(shiny)
library(ggplot2)
library(plotly)


shinyServer(function(input, output) {
  load("populationdf.Rdata")
  
  start <- reactive({input$slider1[1]})
  end <- reactive({input$slider1[2]})
  
  
  pop <- reactive({
    subset(populationdf, Year >= start() & Year <= end())
  })
   
  output$plot <- renderPlotly({
    ggplotly(ggplot(pop(), aes(x=Year)) + geom_line(aes(y=Men, group=1), color="blue") + geom_line(aes(y=Women, group=1), color="red") + geom_line(aes(y=Total, group=1), color="green")) + ggtitle(label="Svensk befolkning 1860-2017")
  })
  
})
