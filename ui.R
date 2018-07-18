library(DT)
library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(
    dashboardHeader(title = "Trade Data"),
    dashboardSidebar(
      
      sidebarUserPanel("Jinsoo Kim"),
      sidebarMenu(
        menuItem("Introduction", tabName = "introduction", icon = icon("bookmark")),
        menuItem("Explore", tabName = "explore", icon = icon("search")),
        menuItem("Graphs", tabName = "graphs", icon = icon("signal")),
        menuItem("Tables", tabName = "tables", icon = icon("th")),
        menuItem("Empty now", tabName = "empty", icon = icon("circle"))
      ),
      
      selectizeInput("selected_country", "Country", country_choice),
      
      selectizeInput("selected_year", "Year", year_choice)
    ),
    
    dashboardBody(
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
      ),
      tabItems(
        tabItem(tabName = "introduction",
                fluidRow(box(title='Hello, My name is Jinsoo Kim', width=12, 'Here is shiny app I\'m work through.',
                             br(),'I\'ll visualize trade data from South Korea to EU countries.',
                             br(),'Thank you for visiting.'))),
        
        tabItem(tabName = "explore",
                fluidRow(infoBoxOutput("maxBox"),
                         infoBoxOutput("minBox"),
                         infoBoxOutput("avgBox")),
                fluidRow(box(htmlOutput("map"), height = 400),
                         box(htmlOutput("bar"), height = 400))),
        
        tabItem(tabName = "graphs",
                fluidRow(box(title='graphs', 'googlecombochart', width=12))),
        
        tabItem(tabName = "tables",
                fluidRow(box(DT::dataTableOutput("table"), width=12))),
        
        tabItem(tabName = "empty",
                fluidRow(box(title='empty page', 'empty now..', width=12)))
        
      )
    )
  ))