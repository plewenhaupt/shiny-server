options(shiny.sanitize.errors = FALSE)
library(shiny)
library(ggplot2)
library(plotly)

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
                  value = c(1860, 2016))
    ),

    mainPanel(
    plotlyOutput("plot")
      )
    )
  )
)

