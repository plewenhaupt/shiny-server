
library(shiny)
library(httr)
library(jsonlite)
library(dplyr)
library(data.table)
library(ggplot2)
library(scales)
library(plotly)
library(lubridate)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Visualizations of Swedish statistics - Proof of concept 1"),

    mainPanel(
      tabsetPanel(
        tabPanel("Population"),
        tabPanel("Something")
      )
    )
  )
)
