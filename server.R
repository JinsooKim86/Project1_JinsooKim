library(DT)
library(shiny)
library(googleVis)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output){
  output$map <- renderGvis({
    gvisGeoChart(trade_data_agg[trade_data_agg$year == input$selected_year, ], 'country', 'export_amount',
                 options=list(region="150", displayMode="regions", 
                              resolution="countries",
                              width="auto", height="auto"))
  })
  
  output$bar <- renderGvis({
    gvisBarChart(trade_data, xvar = input$selected_country, yvar = 'export_amount')
  })
  
  output$table <- DT::renderDataTable({
    datatable(trade_data, rownames=FALSE) %>% 
      formatStyle(input$selected, background="skyblue", fontWeight='bold')
  })
  
  output$maxBox <- renderInfoBox({
    max_value <- max(trade_data[,input$selected])
    max_state <- 
      trade_data$country[trade_data[,input$selected] == max_value]
    infoBox(max_state, max_value, icon = icon("hand-o-up"))
  })
  output$minBox <- renderInfoBox({
    min_value <- min(trade_data[,input$selected])
    min_state <- 
      trade_data$country[trade_data[,input$selected] == min_value]
    infoBox(min_state, min_value, icon = icon("hand-o-down"))
  })
  output$avgBox <- renderInfoBox(
    infoBox(paste("AVG.", input$selected),
            mean(trade_data[,input$selected]), 
            icon = icon("calculator"), fill = TRUE))
})