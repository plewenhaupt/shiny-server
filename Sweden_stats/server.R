library(shiny)


shinyServer(function(input, output) {
  load("populationdf.Rdata")
   
  output$popPlot <- renderPlot({
    plot(x=populationdf$Year, y=populationdf$Total)
  })
  
})
