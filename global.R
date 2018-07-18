# create variable with colnames as choice
trade_data <- read.csv('trade_table.csv', stringsAsFactors = FALSE)
library(dplyr)
trade_data[trade_data$country == 'UK', ]$country <- 'GB'
choice <- colnames(trade_data %>% select('year', 'export_weight', 'import_weight', 'export_amount', 'import_amount', 'trade_balance', 'HS_code', 'description'))