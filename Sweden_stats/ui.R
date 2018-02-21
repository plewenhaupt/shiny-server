
library(shiny)
library(ggplot2)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Visualizations of Swedish statistics - Proof of concept 1"),
  
  sidebarLayout(
    sidebarPanel(
      
      verbatimTextOutput("range"),
      
      sliderInput("slider1",
                  "Years:",
                  min = 1860,
                  max = 2016,
                  value = c(1860, 1900))
    ),

    mainPanel(
    plotOutput("plot")
      )
    )
  )
)

