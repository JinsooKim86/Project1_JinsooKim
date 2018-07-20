library(DT)
library(shiny)
library(googleVis)
library(dplyr)
library(ggplot2)
library(leaflet)

shinyServer(function(input, output) {
  
  points <- eventReactive(input$recalc, {
    cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
  }, ignoreNULL = FALSE)
  
  output$mymap <- renderLeaflet({
    leaflet(width = 400, height = 400) %>% addTiles() %>% addPopups(lng = stations$lng, lat = stations$lat, popup = stations$popup)
  })
  
  output$map <- renderGvis({
    chartdata <- trade_data %>% group_by(year, country) %>% summarise(Export = sum(export_amount), Import = sum(import_amount))
    gvisGeoChart(chartdata[chartdata$year == input$year_ui, ], 'country', input$exim_ui, options = list(region = '150', displayMode = 'regions', resolution = 'countries', width = 'auto', height = 'auto'))
  })
  
  output$bar <- renderPlot({
    plotdata <- trade_data %>% select(year, country, Export = export_amount, Import = import_amount, HS_code)
    ggplot(plotdata[plotdata$country == input$country_ui & plotdata$year == input$year_ui, ], aes(x = reorder(HS_code, -Export), y = Export, fill = HS_code)) + geom_bar(stat = 'identity') + xlab('HS_code') + ylab('Amount 1,000USD')
  })
  
  output$table <- DT::renderDataTable({
    tabledata <- trade_data %>% select(year, country, export_amount, export_weight, import_amount, import_weight, HS_code, description)
    datatable(tabledata, rownames = FALSE) %>% formatStyle(input$selected, background = 'skyblue', fontWeight = 'bold')
  })
  
  output$top <- renderPlot({
    topplot <- trade_data %>% select(year, country, export_weight, export_amount, import_weight, import_amount, HS_code, description) %>% arrange(desc(export_amount))
    topplot <- topplot[topplot$year == input$year2_ui & topplot$country == input$country2_ui, ] %>% head(input$rank2_ui)
    ggplot(topplot, aes(x = reorder(HS_code, -export_amount), y = export_amount, fill = HS_code)) + geom_bar(stat = 'identity') + geom_text(aes(label=description), size=3) + coord_flip() + xlab('HS_code') + ylab('Amount 1,000USD')
  })
  
  #output$weight <- renderPlot({
    #topplot <- trade_data %>% select(year, country, export_weight, export_amount, import_weight, import_amount, HS_code, description) %>% arrange(desc(export_amount))
    #topplot <- topplot[topplot$year == input$year2_ui & topplot$country == input$country2_ui, ] %>% head(input$rank2_ui)
    #ggplot(trade_data[trade_data$HS_code == topplot$HS_code & trade_data$year == input$year2_ui, ], aes(x = export_amount, y = export_weight, col = HS_code)) + geom_point(stat = 'identity', position = 'jitter')
  #})
  
  output$weight <- renderPlot({
    topplot <- trade_data %>% select(year, country, export_weight, export_amount, import_weight, import_amount, HS_code, description) %>% arrange(desc(export_amount))
    topplot <- topplot[topplot$year == input$year2_ui & topplot$country == input$country2_ui, ] %>% head(input$rank2_ui)
    ggplot(trade_data[trade_data$HS_code == topplot$HS_code & trade_data$year == input$year2_ui, ], aes(x=export_amount, y=export_weight, color=HS_code, size=export_weight)) + geom_point(stat = 'identity', position = 'jitter')
  })
})