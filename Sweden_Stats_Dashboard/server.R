options(shiny.sanitize.errors = FALSE)
library(shiny)
library(ggplot2)
library(plotly)
library(scales)
library(dplyr)
library(forecast)

# IMPORT DATA ###################################################################
#The data is pulled from the SCB database through API calls.
source('datapullPop.R')
source('datapullDebt.R')
source('datapull_Mean_Age.R')
source('datapull_Born.R')
source('datapull_Dead.R')

# SERVER  #######################################################################
shinyServer(function(input, output) {
  
  #Sliders
  Popstart <- reactive({input$slider1[1]})
  Popend <- reactive({input$slider1[2]})
  
  Bornstart <- reactive({input$slider2[1]})
  Bornend <- reactive({input$slider2[2]})
  
  MeanAgestart <- reactive({input$slider3[1]})
  MeanAgeend <- reactive({input$slider3[2]})
  
  #Debtstart <- reactive({input$DebtDate[1]})
  #Debtend <- reactive({input$DebtDate[2]})
  
  
  #Dataframes
  pop <- reactive({
    subset(Popdf, Year >= Popstart() & Year <= Popend())
  })
  
  #Combine born and dead dfs
  
  BornDeaddf <- full_join(Borndf, Deaddf)
  Births_Deaths_Diff <- BornDeaddf$Births_Total - BornDeaddf$Deaths_Total
  
  borndead <- reactive({
    subset(BornDeaddf, Year >= Bornstart() & Year <= Bornend())
  })
  
  age <- reactive({
    subset(MeanAgedf, Year >= Bornstart() & Year <= Bornend())
  })
  
  
  #NatDebtdf <- reactive({
  #subset(NatDebtdf, Datum >= Debtstart() & Datum <= Debtend())
  #})
  
# OUTPUTS #######################################################################
  #Population plot
  output$popplot <- renderPlotly({
    
    popplot <- ggplotly(ggplot(pop(), aes(x=Year)) 
             + geom_line(aes(y=Men, group=1), color="blue") 
             + geom_line(aes(y=Women, group=1), color="red") 
             + geom_line(aes(y=Total, group=1), color="green") 
             + scale_y_continuous(labels = comma) 
             + theme(axis.title.y=element_blank(), axis.text.y=element_text(size = 7), plot.margin = margin(10, 10, 20, 25)) 
             + ggtitle(label="Swedish Population Growth"))
  })
  
  output$relpopplot <- renderPlotly({
    relpopplot <- ggplotly(ggplot(pop(), aes(x=Year)) 
             + geom_line(aes(y=Relative_Growth, group=1), color="black") 
             + scale_y_continuous(labels = comma) 
             + theme(axis.title.y=element_blank(), axis.text.y=element_text(size = 7), plot.margin = margin(10, 10, 20, 25)) 
             + ggtitle(label="Relative Population Growth"))
  })
  
  output$borndeadplot <- renderPlotly({
    borndeadplot <- ggplotly(ggplot(borndead(), aes(x=Year)) 
             + geom_line(aes(y=Births_Men, group=1), color="dodgerblue2") 
             + geom_line(aes(y=Births_Women, group=1), color="red") 
             + geom_line(aes(y=Births_Total, group=1), color="green") 
             + geom_line(aes(y=Deaths_Men, group=1), color="blue") 
             + geom_line(aes(y=Deaths_Women, group=1), color="darkred") 
             + geom_line(aes(y=Deaths_Total, group=1), color="palegreen4") 
             + scale_y_continuous(labels = comma) 
             + theme(axis.title.y=element_blank(), axis.text.y=element_text(size = 7), plot.margin = margin(10, 10, 20, 25)) 
             + ggtitle(label="Births and Deaths per Year"))
  })
  
  output$ageplot <- renderPlotly({
    ggplotly(ggplot(age(), aes(x=Year)) 
             + geom_line(aes(y=Men, group=1), color="blue") 
             + geom_line(aes(y=Women, group=1), color="red") 
             + geom_line(aes(y=Total, group=1), color="green") 
             + scale_y_continuous(labels = comma) 
             + theme(axis.title.y=element_blank(), axis.text.y=element_text(size = 7), plot.margin = margin(10, 10, 20, 25)) 
             + ggtitle(label="Population Mean Age"))
  })
  #Debt plot
  output$Debtplot <- renderPlotly({
    ggplotly(ggplot(NatDebtdf, aes(x=Datum, text=paste0("Date: ", as.Date(Datum)))) 
             + geom_line(aes(y=Debt, group=1))
             + theme(axis.title=element_blank(), axis.text.y=element_text(size = 7), plot.margin = margin(10, 10, 20, 25))
             + ggtitle(label="Swedish National Debt"), tooltip=c("y", "text"))
  })
  
  
  #BNP plot
  output$BNPplot <- renderPlot({
    autoplot(ts_BNPanvCut) + geom_forecast()
  })
  
  #output$table <- renderTable(NatDebtdf())
  #output$end <- renderText(Debtstart())
})
