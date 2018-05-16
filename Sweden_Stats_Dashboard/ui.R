options(shiny.sanitize.errors = FALSE)
library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(scales)

source('datapullPop.R')
source('datapullDebt.R')




# HEADER  #######################################################################
header <- dashboardHeader(title = "Statistics Sweden")


# SIDEBAR #######################################################################
sidebar <-   dashboardSidebar(
  sidebarMenu(
    menuItem("Population", tabName = "population", icon = icon("male")),
    menuItem("Finances", tabName = "finances", icon = icon("coins"))
  )
)


# BODY  #########################################################################
body <- dashboardBody(tabItems(
  # First tab content
  tabItem(tabName = "population",
          fluidRow(
            box(plotlyOutput("popplot", height = 500)),
            
            box(
              title = "Controls",
              sliderInput("slider1",
                          "Years:",
                          min = minPopYear,
                          max = maxPopYear,
                          value = c(minPopYear, maxPopYear))
            )
          )
  ),
  
  # Second tab content
  tabItem(tabName = "finances",
          fluidRow(
            box(plotlyOutput("Debtplot", height = 250)),
            
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
