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
  sidebarMenu(
    menuItem("Population", tabName = "population", icon = icon("male")),
    menuItem("Finances", tabName = "finances", icon = icon("money"))
  )
)


# BODY  #########################################################################
body <- dashboardBody(tabItems(
  # First tab content
  tabItem(tabName = "population",
          fluidRow(
            box(plotlyOutput("popplot")),
            box(plotlyOutput("relpopplot"))
            ),
          
          
          fluidRow(box(width=12,
            title = "Years - Population Growth",
            sliderInput("slider1",
                        "Years:",
                        min = minPopYear,
                        max = maxPopYear,
                        value = c(minPopYear, maxPopYear))
          )),
          
          fluidRow(
            box(width=12, plotlyOutput("borndeadplot"))
          ),
          
          fluidRow(box(width=12,
                       title = "Births and Death",
                       sliderInput("slider2",
                                   "Years:",
                                   min = minBornYear,
                                   max = maxBornYear,
                                   value = c(minBornYear, maxBornYear))
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
            )
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
