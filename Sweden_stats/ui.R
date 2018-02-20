
library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Visualizations of Swedish statistics - Proof of concept 1"),

    mainPanel(
      tabsetPanel(
        tabPanel("Population", plotlyOutput("popPlot")),
        tabPanel("Summary"),
        tabPanel("Table")
      )
    )
  )
)
