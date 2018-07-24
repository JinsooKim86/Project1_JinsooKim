library(DT)
library(shiny)
library(googleVis)
library(dplyr)
library(ggplot2)
library(leaflet)
library(tidyverse)
library(packcircles)
library(viridis)
library(ggiraph)

shinyServer(function(input, output) {

  output$map <- renderGvis({
    chartdata <- trade_data %>% group_by(year, country) %>% summarise(Export = sum(export_amount, na.rm = TRUE), Import = sum(import_amount, na.rm = TRUE), Trade_Balance = sum(trade_balance, na.rm = TRUE))
    gvisGeoChart(chartdata[chartdata$year == input$year_ui, ], 'country', input$exim_ui, options = list(region = '150', displayMode = 'regions', resolution = 'countries', width = 800, height = 480))
  })
  
  output$circle <- renderPlot({
    data <- trade_data %>% select(year, country, group = class, value = ifelse(input$exim2_ui == 'Export', 'export_amount', ifelse(input$exim2_ui == 'Import', 'import_amount', ifelse(input$exim2_ui == 'Trade_Balance', 'trade_balance', '')))) %>% group_by(year, country, group) %>% summarise(value = sum(value))
    data <- data[data$year == input$year2_ui & data$country == input$country2_ui, ]
    data <- data.frame(data$group, data$value)
    data <- data %>% rename(group = data.group, value = data.value)
    data$value <- data$value ** 0.5
    data$text=paste("Class : ",data$group, "\n", input$exim2_ui, data$value)
    packing <- circleProgressiveLayout(data$value, sizetype='area')
    data = cbind(data, packing)
    dat.gg <- circleLayoutVertices(packing, npoints = 50)
    plot <- ggplot() + 
      geom_polygon_interactive(data = dat.gg, aes(x, y, group = id, fill = id, tooltip = data$text[id], data_id = id), colour = 'black', alpha = 0.6) + 
      scale_fill_viridis() + 
      geom_text(data = data, aes(x,y,label = group), check_overlap = TRUE, size = 4, color = 'black') + 
      theme_void() + 
      theme(legend.position = 'none', plot.margin = unit(c(-1,-1,-1,-1), 'cm')) + 
      coord_equal()
    plot
  })
  
  output$explore_text <- renderPrint({
    cat(input$year2_ui, 'Major', input$exim2_ui, 'Commodities to/from', input$country2_ui)
  })
  
  output$explore_plot <- renderPlot({
    barplotdata <- trade_data %>% group_by(year, country, class) %>% summarise(Amount = sum(ifelse(input$exim2_ui == 'Export', export_amount, ifelse(input$exim2_ui == 'Import', import_amount, ''))))
    barplotdata <- barplotdata[barplotdata$year == input$year2_ui & barplotdata$country == input$country2_ui, ] %>% arrange(desc(Amount)) %>% head(5)
    ggplot(barplotdata, aes(x = reorder(class, Amount), y = Amount, fill = class)) + xlab(' ') + ylab('Amount (1,000USD)') + geom_bar(stat = 'identity') + theme(legend.position="none", axis.text.y=element_blank()) + geom_text(aes(label=class, hjust = 0), position = position_stack(vjust = 0)) + coord_flip() 
  })
  
  output$table <- DT::renderDataTable({
    tabledata <- trade_data %>% select(year, country, export_amount, export_weight, import_amount, import_weight, hs_code, description, class)
    datatable(tabledata, rownames = FALSE) %>% formatStyle(input$selected, background = 'skyblue', fontWeight = 'bold')
  })
  
  output$comparing_text1 <- renderPrint({
    cat('South Korea to', input$country3_ui)
  })
  
  output$comparing_plot1 <- renderPlot({
    comp_data <- trade_data %>% select(year, country, export_amount, import_amount, class, description, hs_code) %>% group_by(year, country, class, description, hs_code) %>% summarise(Export = sum(export_amount), Import = sum(import_amount)) %>% mutate(Total = Export + Import)
    comp_data <- comp_data[comp_data$year == input$year3_ui & comp_data$country == input$country3_ui, ] %>% arrange(desc(Total)) %>% head(input$rank3_ui)
    ggplot(comp_data, aes(x = reorder(description, Total), y = Export, fill = class)) + geom_bar(stat = 'identity') + scale_y_continuous(labels = scales::comma) + theme(legend.position="none", axis.text.y=element_blank()) + geom_text(aes(label=description, hjust = 0), position = position_stack(vjust = 0)) + coord_flip() + xlab('Commodity') + ylab('Amount 1,000USD')
  })
  
  output$comparing_text2 <- renderPrint({
    cat(input$country3_ui, 'to South Korea')
  })
  
  output$comparing_plot2 <- renderPlot({
    comp_data <- trade_data %>% select(year, country, export_amount, import_amount, class, description, hs_code) %>% group_by(year, country, class, description, hs_code) %>% summarise(Export = sum(export_amount), Import = sum(import_amount)) %>% mutate(Total = Export + Import)
    comp_data <- comp_data[comp_data$year == input$year3_ui & comp_data$country == input$country3_ui, ] %>% arrange(desc(Total)) %>% head(input$rank3_ui)
    ggplot(comp_data, aes(x = reorder(description, Total), y = Import, fill = class)) + geom_bar(stat = 'identity') + scale_y_continuous(labels = scales::comma) + theme(legend.position="none", axis.text.y=element_blank()) + geom_text(aes(label=description, hjust = 0), position = position_stack(vjust = 0)) + coord_flip() + xlab('Commodity') + ylab('Amount 1,000USD')
  })
  
  output$countryplot <- renderPlot({
    trend_data <- trade_data %>% select(year, country, class, Amount = ifelse(input$exim5_ui == 'Export', 'export_amount', 'import_amount')) %>% group_by(year, country, class) %>% summarise(Amount = sum(Amount))
    trend_data <- trend_data[trend_data$country == input$country5_ui, ]
    agg_data <- trend_data %>% group_by(country,class) %>% summarise(Amount = sum(Amount)) %>% arrange(desc(Amount)) %>% head(input$highrank5_ui)
    trend_data <- trend_data[trend_data$class %in% unique(agg_data$class), ]
    ggplot(trend_data, aes(x = year, y = Amount, group = class, color = class)) + geom_point(aes(size = Amount)) + geom_line(stat = 'identity') + scale_y_continuous(labels = scales::comma)
  })
  
  output$trendplot <- renderPlot({
    trend_data <- trade_data %>% select(year, country, description, hs_code, Amount = ifelse(input$exim4_ui == 'Export', 'export_amount', 'import_amount'))
    agg_data <- trend_data %>% group_by(country, description) %>% summarise(Amount = sum(Amount))
    rank <- agg_data[agg_data$description == input$commodity_ui, ] %>% arrange(desc(Amount)) %>% head(input$highrank_ui)
    trend_data <- trend_data[trend_data$country %in% unique(rank$country) & trend_data$description == input$commodity_ui & trend_data$year != 2018, ]
    ggplot(trend_data, aes(x = year, y = Amount, group = country, color = country)) + geom_point(aes(size = Amount)) + geom_line(stat = 'identity') + scale_y_continuous(labels = scales::comma)
  })
  
  output$top <- renderPlot({
    topplot <- trade_data %>% select(year, country, export_weight, export_amount, import_weight, import_amount, hs_code, description) %>% arrange(desc(export_amount))
    topplot <- topplot[topplot$year == input$year2_ui & topplot$country == input$country2_ui, ] %>% head(input$rank2_ui)
    ggplot(topplot, aes(x = reorder(hs_code, -export_amount), y = export_amount, fill = hs_code)) + geom_bar(stat = 'identity') + geom_text(aes(label=description), size=3) + coord_flip() + xlab('HS_code') + ylab('Amount 1,000USD')
  })
  
  #output$weight <- renderPlot({
    #topplot <- trade_data %>% select(year, country, export_weight, export_amount, import_weight, import_amount, HS_code, description) %>% arrange(desc(export_amount))
    #topplot <- topplot[topplot$year == input$year2_ui & topplot$country == input$country2_ui, ] %>% head(input$rank2_ui)
    #ggplot(trade_data[trade_data$HS_code == topplot$HS_code & trade_data$year == input$year2_ui, ], aes(x = export_amount, y = export_weight, col = HS_code)) + geom_point(stat = 'identity', position = 'jitter')
  #})
  
  output$weight <- renderPlot({
    topplot <- trade_data %>% select(year, country, export_weight, export_amount, import_weight, import_amount, hs_code, description) %>% arrange(desc(export_amount))
    topplot <- topplot[topplot$year == input$year2_ui & topplot$country == input$country2_ui, ] %>% head(input$rank2_ui)
    ggplot(trade_data[trade_data$hs_code == topplot$hs_code & trade_data$year == input$year2_ui, ], aes(x=export_amount, y=export_weight, color=hs_code, size=export_weight)) + geom_point(stat = 'identity', position = 'jitter')
  })
  
  output$bar <- renderPlot({
    plotdata <- trade_data %>% select(year, country, Export = export_amount, Import = import_amount, hs_code)
    ggplot(plotdata[plotdata$country == input$country_ui & plotdata$year == input$year_ui, ], aes(x = reorder(hs_code, -Export), y = Export, fill = hs_code)) + geom_bar(stat = 'identity') + xlab('HS_code') + ylab('Amount 1,000USD')
  })
  
})