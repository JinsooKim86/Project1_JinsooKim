library(dplyr)
trade_data <- read.csv('trade_data.csv', stringsAsFactors = FALSE)

trade_data <- trade_data %>% mutate(class=ifelse(trade_data$hs_code %in% c(1,2,3,4,5), 'Animal & Animal Products', ifelse(trade_data$hs_code %in% c(6,7,8,9,10,11,12,13,14,15), 'Vegetable Products', ifelse(trade_data$hs_code %in% c(16,17,18,19,20,21,22,23,24), 'Foodstuffs', ifelse(trade_data$hs_code %in% c(25,26,27), 'Mineral Products', ifelse(trade_data$hs_code %in% c(28,29,30,31,32,33,34,35,36,37,38), 'Chemicals & Allied Industries', ifelse(trade_data$hs_code %in% c(39,40), 'Plastics/Rubbers', ifelse(trade_data$hs_code %in% c(41,42,43), 'Raw Hides, Skins, Leather & Furs', ifelse(trade_data$hs_code %in% c(44,45,46,47,48,49), 'Wood & Wood Products', ifelse(trade_data$hs_code %in% c(50,51,52,53,54,55,56,57,58,59,60,61,62,63), 'Textiles', ifelse(trade_data$hs_code %in% c(64,65,66,67), 'Footwear/Headgear', ifelse(trade_data$hs_code %in% c(68,69,70,71), 'Stone/Glass', ifelse(trade_data$hs_code %in% c(72,73,74,75,76,77,78,79,80,81,82,83), 'Metals', ifelse(trade_data$hs_code %in% c(84,85), 'Machinery/Electrical', ifelse(trade_data$hs_code %in% c(86,87,88,89), 'Transportation', ifelse(trade_data$hs_code %in% c(90,91,92,93,94,95,96,97,98,99), 'Miscellaneous',''))))))))))))))))

trade_data$hs_code <- sprintf('%02d', trade_data$hs_code)
trade_data <- trade_data %>% arrange(year, country, desc(export_amount))

exim_glo <- c('Export', 'Import', 'Trade_Balance')
years_glo <- unique(trade_data$year)
countries_glo <- unique(trade_data$country)
commodities_glo <- unique(trade_data$description)
class_glo <- unique(trade_data$class)

stations <- data.frame(lng = c(104.305018, 24.9384, 13.4050, 7.2620, 2.3354, 37.6573, 131.881622, 125.736423, 129.042259, 60.605703, 92.893248), 
                       lat = c(52.286974, 60.1699, 52.5200, 43.7102, 48.8373, 55.7768, 43.111274, 39.004894, 35.115214, 56.838926, 56.015283), 
                       popup = c('Irkutsk', 'Helsinki', 'Berlin', 'Nice', 'Paris', 'Moscow', 'Vladivostok', 'Pyongyang', 'Busan', 'Ekaterinburg', 'Krasnoyarsk'))