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
    ggplot(plotdata[plotdata$country == input$country_ui & plotdata$year == input$year_ui, ], aes(x = reorder(HS_code, -Export), y = Export, fill = HS_code)) + geom_bar(stat = 'identity')
  })
  
  output$table <- DT::renderDataTable({
    tabledata <- trade_data %>% select(year, country, export_amount, export_weight, import_amount, import_weight, HS_code, description)
    datatable(tabledata, rownames = FALSE) %>% formatStyle(input$selected, background = 'skyblue', fontWeight = 'bold')
    
  })
})