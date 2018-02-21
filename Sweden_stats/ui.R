
library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Visualizations of Swedish statistics - Proof of concept 1"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),

    mainPanel(
    plotOutput("popPlot")
      )
    )
  )
)

