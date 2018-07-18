trade_data <- read.csv('trade_table.csv', stringsAsFactors = FALSE)
library(dplyr)
trade_data[trade_data$country == 'UK', ]$country <- 'GB'

trade_data$HS_code <- sprintf('%02d', trade_data$HS_code)


trade_data <- trade_data %>% select(year, country, export_weight, export_amount, HS_code, description) %>% arrange(country, desc(export_amount))
trade_data_agg <- trade_data %>% group_by(country, year) %>% summarise(export_amount = sum(export_amount), export_weight = sum(export_weight))

country_choice <- unique(trade_data_agg$country)
year_choice <- unique(trade_data_agg$year)
