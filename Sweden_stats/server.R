options(shiny.sanitize.errors = FALSE)
library(shiny)
library(ggplot2)
library(plotly)
library(scales)
library(dplyr)
library(forecast)

source('datapullPop.R')
source('datapullDebt.R')
source('datapullBNPanv.R')

shinyServer(function(input, output) {
  
  #Sliders
  Popstart <- reactive({input$slider1[1]})
  Popend <- reactive({input$slider1[2]})
  
  #Debtstart <- reactive({input$DebtDate[1]})
  #Debtend <- reactive({input$DebtDate[2]})
  
  
  #Dataframes
  pop <- reactive({
    subset(populationdf, Year >= Popstart() & Year <= Popend())
  })
  
  
  #NatDebtdf <- reactive({
    #subset(NatDebtdf, Datum >= Debtstart() & Datum <= Debtend())
  #})
  
  output$popplot <- renderPlotly({
    ggplotly(ggplot(pop(), aes(x=Year)) 
    + geom_line(aes(y=Men, group=1), color="blue") 
    + geom_line(aes(y=Women, group=1), color="red") 
    + geom_line(aes(y=Total, group=1), color="green") 
    + scale_y_continuous(labels = comma) 
    + theme(axis.title.y=element_blank(), axis.text.y=element_text(size = 7), plot.margin = margin(10, 10, 20, 25)) 
    + ggtitle(label=paste("Sveriges befolkning ", as.character(minPopYear), " - ", as.character(maxPopYear), sep="")))
  })
  
  output$Debtplot <- renderPlotly({
    ggplotly(ggplot(NatDebtdf, aes(x=Datum, text=paste0("Date: ", as.Date(Datum)))) 
    + geom_line(aes(y=Debt, group=1))
    + theme(axis.title=element_blank(), axis.text.y=element_text(size = 7), plot.margin = margin(10, 10, 20, 25))
    + ggtitle(label="Sveriges statsskuld"), tooltip=c("y", "text"))
  })
  
  output$BNPplot <- renderPlot({
    autoplot(ts_BNPanvCut) + geom_forecast()
  })
  
  #output$table <- renderTable(NatDebtdf())
  #output$end <- renderText(Debtstart())
})
