library(shiny)


shinyServer(function(input, output) {
  load("populationdf.Rdata")
  
  start <- reactive({input$slider1[1]})
  end <- reactive({input$slider1[2]})
  
  
  pop <- reactive({
    subset(populationdf, Year >= start() & Year <= end())
  })
   
  output$plot <- renderPlot({
    plot(x=pop()$Year, y=pop()$Total)
  })
  
})
