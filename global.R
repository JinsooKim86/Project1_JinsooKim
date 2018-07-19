trade_data <- read.csv('trade_table.csv', stringsAsFactors = FALSE)
library(dplyr)
trade_data[trade_data$country == 'UK', ]$country <- 'GB'

trade_data$HS_code <- sprintf('%02d', trade_data$HS_code)
trade_data$year <- as.integer(trade_data$year)

trade_data <- trade_data %>% select(year, country, export_amount, import_amount, description, HS_code) %>% arrange(country, desc(export_amount))
trade_data_agg <- trade_data %>% group_by(country, year, HS_code) %>% summarise(export_amount = sum(export_amount), import_amount = sum(import_amount))

ei_choice <- c('export_amount', 'import_amount')
year_choice <- unique(trade_data_agg$year)
country_choice <- unique(trade_data_agg$country)