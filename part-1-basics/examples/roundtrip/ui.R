library(shiny)
shinyUI(
  pageWithSidebar(
    headerPanel("The Roundtrip Example"),
    sidebarPanel(
      fileInput('csv_file', 'Choose CSV File',
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv')),
      tags$hr(),
      uiOutput("value_choice"),
      tags$hr(),
      radioButtons(inputId = "log_it", label = "Log Scale?", c("Yes", "No"))
    ), # sidebarPanel
    mainPanel(
      textOutput("description"),
      tags$br(),
      plotOutput("histogram")
    ) # mainpanel
  ) # pageWithSidebar
) # shinyUI
