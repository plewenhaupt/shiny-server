options(shiny.sanitize.errors = FALSE)
library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(scales)

source('datapullPop.R')
source('datapullDebt.R')
source('datapull_Mean_Age.R')
source('datapull_Born.R')
source('datapull_Dead.R')




# HEADER  #######################################################################
header <- dashboardHeader(title = "Statistics Sweden")


# SIDEBAR #######################################################################
sidebar <-   dashboardSidebar(
  sidebarMenu(id="sidebarmenu",
    menuItem("Population", tabName = "population", icon = icon("male")),
    conditionalPanel("input.sidebarmenu === 'population'",
    sliderInput("slider1",
                "Population - Years:",
                min = minPopYear,
                max = maxPopYear,
                value = c(minPopYear, maxPopYear)),
    sliderInput("slider2",
                "Births and Deaths - Years:",
                min = minBornYear,
                max = maxBornYear,
                value = c(minBornYear, maxBornYear))
    ),
    menuItem("Finances", tabName = "finances", icon = icon("money"))
  )
)


# BODY  #########################################################################
body <- dashboardBody(tabItems(
  # First tab content
  tabItem(tabName = "population",
          fluidRow(
            column(width=6,
            box(width=12, plotlyOutput("popplot")),
          
            box(width=12, plotlyOutput("relpopplot"))
            ),
          
          fluidRow(
            column(width=6,
            box(width=12, plotlyOutput("borndeadplot"))
          )),
          
          fluidRow(
            box(plotlyOutput("ageplot")),
            
            box(
              title = "Years - Mean Age",
              sliderInput("slider3",
                          "Years:",
                          min = minMeanAgeYear,
                          max = maxMeanAgeYear,
                          value = c(minMeanAgeYear, maxMeanAgeYear))
            ))
          )
  ),
  
  # Second tab content
  tabItem(tabName = "finances",
          fluidRow(
            box(plotlyOutput("Debtplot")),
            
            box(
              dateRangeInput("DebtDate",
                             "Years:",
                             min = minDebtDate,
                             max = maxDebtDate,
                             start = minDebtDate, 
                             end = maxDebtDate,
                             format ="yyyy-mm-dd",
                             weekstart = 1,
                             startview = "year")
            )
          )
  )
  )
)



# PAGE  #########################################################################
dashboardPage(header, sidebar, body)
