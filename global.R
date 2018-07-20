library(dplyr)
trade_data <- read.csv('trade_table.csv', stringsAsFactors = FALSE)
trade_data[trade_data$country == 'UK', ]$country <- 'GB'
trade_data$HS_code <- sprintf('%02d', trade_data$HS_code)
trade_data <- trade_data %>% arrange(year, country, desc(export_amount))

exim_glo <- c('Export', 'Import')
years_glo <- unique(trade_data$year)
countries_glo <- unique(trade_data$country)

stations <- data.frame(lng = c(104.305018, 24.9384, 13.4050, 7.2620, 2.3354, 37.6573, 131.881622, 125.736423, 129.042259, 60.605703, 92.893248), 
                       lat = c(52.286974, 60.1699, 52.5200, 43.7102, 48.8373, 55.7768, 43.111274, 39.004894, 35.115214, 56.838926, 56.015283), 
                       popup = c('Irkutsk', 'Helsinki', 'Berlin', 'Nice', 'Paris', 'Moscow', 'Vladivostok', 'Pyongyang', 'Busan', 'Ekaterinburg', 'Krasnoyarsk'))

#geochartdata <- trade_data %>% select(year, country, export_amount, import_amount) %>% group_by(year, country) %>% summarise(export = sum(export_amount), import = sum(import_amount))
#barplotdata <- trade_data %>% select(year, country, export_amount, import_amount, HS_code) %>% group_by(year, country, HS_code) %>% summarise(export = sum(export_amount), import = sum(import_amount))
#years <- unique(trade_data$year)