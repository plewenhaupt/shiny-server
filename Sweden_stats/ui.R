options(shiny.sanitize.errors = FALSE)
library(shiny)
library(ggplot2)
library(plotly)
library(scales)

source('datapullPop.R')

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Visualizations of Swedish statistics - Proof of concept 1"),
  tabsetPanel(
    tabPanel("Befolkning",
      sidebarLayout(
        sidebarPanel(
      
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
    ),
    tabPanel("Statsskuld",
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
                 "Här ska grafen vara"
               )
             )
    )
  )
)
)
