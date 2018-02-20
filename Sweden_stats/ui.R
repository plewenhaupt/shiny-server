#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(httr)
library(jsonlite)
library(dplyr)
library(data.table)
library(ggplot2)
library(scales)
library(plotly)
library(lubridate)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Visualizations of Swedish statistics - Proof of concept"),
  
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Population", plotlyOutput("popPlot")),
        tabPanel("Something")
      )
    )
  )
)
