options(shiny.sanitize.errors = FALSE)
library(shiny)
library(ggplot2)
library(plotly)

source('datapull.R')

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Visualizations of Swedish statistics - Proof of concept 1"),
  
  sidebarLayout(
    sidebarPanel(
      
      verbatimTextOutput("range"),
      
      sliderInput("slider1",
                  "Years:",
                  min = minYear,
                  max = maxYear,
                  value = c(minYear, maxYear))
    ),

    mainPanel(
    plotlyOutput("plot")
      )
    )
  )
)

