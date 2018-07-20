library(dplyr)
trade_data <- read.csv('trade_table.csv', stringsAsFactors = FALSE)
trade_data[trade_data$country == 'UK', ]$country <- 'GB'
trade_data$HS_code <- sprintf('%02d', trade_data$HS_code)
trade_data <- trade_data %>% arrange(country)

exim_glo <- c('Export', 'Import')
years_glo <- unique(trade_data$year)
countries_glo <- unique(trade_data$country)

#geochartdata <- trade_data %>% select(year, country, export_amount, import_amount) %>% group_by(year, country) %>% summarise(export = sum(export_amount), import = sum(import_amount))
#barplotdata <- trade_data %>% select(year, country, export_amount, import_amount, HS_code) %>% group_by(year, country, HS_code) %>% summarise(export = sum(export_amount), import = sum(import_amount))
#years <- unique(trade_data$year)