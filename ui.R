library(DT)
library(shiny)
library(shinydashboard)
library(leaflet)
library(tidyverse)

shinyUI(dashboardPage(
  dashboardHeader(title = 'Trade Data'),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem('Introduction', tabName = 'introduction', icon = icon('bookmark')),
      menuItem('Explore', tabName = 'explore', icon = icon('search')),
      menuItem('Comparing Export/Import', tabName = 'compare', icon = icon('clone')),
      menuItem('Trend Plot (Country, Class)', tabName = 'countrytrend', icon = icon('asterisk')),
      menuItem('Trend Plot (Commodity, Country)', tabName = 'trend', icon = icon('asterisk')),
      menuItem('Geochart', tabName = 'geochart', icon = icon('globe')),
      menuItem('Tables', tabName = 'tables', icon = icon('th'))
    )
  ),
  
  dashboardBody(
    tabItems(
      
      tabItem(tabName = 'introduction',
              fluidRow(box(title = 'Hello,', 'My name is Jinsoo Kim. This is my shinyapp for NYCDSA project 1. Basically, This app provides export and import data between Euopean countries and South Korea.', br(),
                           'I hope that this app helps you predict which commodities would be promising for the trade between European countries and South Korea in the near future.', br(),
                           'Thank you for visiting.', width = 12)),
              fluidRow(column(4,box(selectizeInput('exim_ui', 'Data', exim_glo), 
                                    selectizeInput('year_ui', 'Year', years_glo),
                                    width = 'auto', height = 500)), 
                       column(8,box(htmlOutput('map'), width = 'auto')))),
      
      tabItem(tabName = 'explore',
              fluidRow(column(4,box(selectizeInput('exim2_ui', 'Data', exim_glo),
                                    selectizeInput('country2_ui', 'Country', countries_glo),
                                    selectizeInput('year2_ui', 'Year', years_glo), width = 'auto'),
                              box(textOutput('explore_text'),
                                  plotOutput('explore_plot', height = 320), width = 'auto')), 
                       column(8,box(plotOutput('circle', width = 700, height = 620), width = 'auto')))),
      
      tabItem(tabName = 'compare',
              fluidRow(column(4,box(selectizeInput('country3_ui', 'Country', countries_glo),
                                    selectizeInput('year3_ui', 'Year', years_glo),
                                    sliderInput('rank3_ui', 'Trade Amount Ranking', min = 1, max = 15, value = 15, step = 1),
                                    width = 'auto', height = 620)), 
                       column(4,box(textOutput('comparing_text1'), plotOutput('comparing_plot1', height = 580), width = 'auto', height = 620)),
                       column(4,box(textOutput('comparing_text2'), plotOutput('comparing_plot2', height = 580), width = 'auto', height = 620)))),
      
      tabItem(tabName = 'countrytrend',
              fluidRow(box(plotOutput('countryplot'), width = 'auto', height = 500)),
              fluidRow(column(4, box(selectizeInput('exim5_ui', 'Data', exim_glo), width = 'auto', height = 200)),
                       column(4, box(sliderInput('highrank5_ui', 'Number of high ranked class', min = 1, max = 15, value = 15, step = 1), width = 'auto', height = 100)), 
                       column(4, box(selectizeInput('country5_ui', 'Country', countries_glo), width = 'auto', height = 100)))),
      
      tabItem(tabName = 'trend',
              fluidRow(box(plotOutput('trendplot'), width = 'auto', height = 500)),
              fluidRow(column(4, box(selectizeInput('exim4_ui', 'Data', exim_glo), width = 'auto', height = 200)), 
                       column(4, box(sliderInput('highrank_ui', 'Number of high ranked countries', min = 1, max = 10, value = 10, step = 1), width = 'auto', height = 100)), 
                       column(4, box(selectizeInput('commodity_ui', 'Commodity', commodities_glo), width = 'auto', height = 100)), width = 'auto', height = 100)),
        
      tabItem(tabName = 'tables',
              fluidRow(box('(Unit : amount 1,000USD, weight 1ton)', DT::dataTableOutput('table'), width=12))),
      
      tabItem(tabName = 'geochart',
              fluidRow(column(2, box(selectizeInput('exim6_ui', 'Data', exim_glo), 
                                     selectizeInput('year6_ui', 'Year', years_glo),
                                     selectizeInput('commodity6_ui', 'Commodity', commodities_glo), width = 'auto', height = 620)),
                       column(10, box(htmlOutput('geochart'), width = 'auto', height = 620))))
    )
  )
))