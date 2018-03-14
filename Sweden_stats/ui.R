options(shiny.sanitize.errors = FALSE)
library(shiny)
library(ggplot2)
library(plotly)
library(scales)

source('datapullPop.R')
source('datapullDebt.R')

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Visualizations of Swedish statistics - Proof of concept 1"),
  tabsetPanel(
    tabPanel("Befolkning",
      sidebarLayout(
        sidebarPanel(
      
          sliderInput("slider1",
                      "Years:",
                      min = minPopYear,
                      max = maxPopYear,
                      value = c(minPopYear, maxPopYear))
        ),

        mainPanel(
          plotlyOutput("popplot")
        )
      )
    ),
    
    tabPanel("Statsskuld",
      sidebarLayout(
        sidebarPanel(
          dateRangeInput("DebtDate",
                      "Years:",
                      min = minDebtDate,
                      max = maxDebtDate,
                      start = minDebtDate, 
                      end = maxDebtDate,
                      format ="yyyy-mm-dd",
                      weekstart = 1,
                      startview = "year")
        ),
               
        mainPanel(
          plotlyOutput("Debtplot")
          #tableOutput("table")
          #verbatimTextOutput(end)
        )
      )
    ), 
    tabPanel("BNP (användning)",
             sidebarLayout(
               sidebarPanel(
                 dateRangeInput("BNP",
                                "Years:",
                                min = minDebtDate,
                                max = maxDebtDate,
                                start = minDebtDate, 
                                end = maxDebtDate,
                                format ="yyyy-mm-dd",
                                weekstart = 1,
                                startview = "year")
               ),
               
               mainPanel(
                 plotOutput("BNPplot")
                 #tableOutput("table")
                 #verbatimTextOutput(end)
               )
             )
    )
  )
)
)
