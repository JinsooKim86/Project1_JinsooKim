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
    leaflet(width = 400, height = 400) %>% addPopups(104.305018, 52.286974, 'Irkutsk') %>% addPopups(24.9384, 60.1699, 'Helsinki') %>% addPopups(13.4050, 52.5200, 'Berlin') %>% addPopups(7.2620, 43.7102, 'Nice') %>% addPopups(2.3354, 48.8373, 'Paris') %>% addTiles() %>% addPopups(37.6573, 55.7768, 'Moscow') %>% addPopups(131.881622, 43.111274, 'Vladivostok') %>% addPopups(125.736423, 39.004894, 'Pyongyang') %>% addPopups(129.042259, 35.115214, 'Busan') 
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