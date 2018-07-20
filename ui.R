library(DT)
library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(
  dashboardHeader(title = 'Trade Data'),
  
  dashboardSidebar(
    sidebarUserPanel('Jinsoo Kim'),
    sidebarMenu(
      menuItem('Introduction', tabName = 'introduction', icon = icon('bookmark')),
      menuItem('Explore', tabName = 'explore', icon = icon('search')),
      menuItem('Graphs', tabName = 'graphs', icon = icon('signal')),
      menuItem('Tables', tabName = 'tables', icon = icon('th')),
      menuItem('Empty now', tabName = 'empty', icon = icon('circle'))
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$link()
    ),
    tabItems(
      
      tabItem(tabName = 'introduction',
              fluidRow(box(title='Introduction',
                           'Hello, my name is Jinsoo Kim. Here is shinyapp I\'m working through.', br(), 
                           'Topic would be Estimation of Economy Effects from Trans-Siberian Railway Connection to South Korea.', br(), 
                           'Thank you for visiting.')),
              fluidRow(leafletOutput("mymap"))),
      
      tabItem(tabName = 'explore',
              fluidRow(box(selectizeInput('exim_ui', 'Export/Import', exim_glo),
                           sliderInput('year_ui', 'Year', min = min(years_glo), max = max(years_glo), value = 1, step = 1), width = 6, height = 200),
                       box(selectizeInput('country_ui', 'Country', countries_glo), 
                           sliderInput('rank_ui', 'Product Trade Rank', min = 1, max = 10, value = 1, step = 1), width = 6, height = 200)),
              fluidRow(box(htmlOutput('map'), height = 400),
                       box(plotOutput('bar'), height = 400))),
      
      tabItem(tabName = 'graphs',
              fluidRow(box(title = 'graphs', '...', width=12))),
      
      tabItem(tabName = 'tables',
              fluidRow(box(DT::dataTableOutput('table'), width=12))),
      
      tabItem(tabName = 'empty',
              fluidRow(box(title = 'empty now...', '...', width=12)))
    )
  )
))