library(plotly)


shinyUI(
  fluidPage(
    tabsetPanel(
      tabPanel("Scatter Plot",
               mainPanel(plotlyOutput("scatter"))
      ), # End "Scatter Plot" tabPanel
      tabPanel("Scatter Plot with Conditioning",
               mainPanel(plotlyOutput("conditioning"))
      ), # End "Scatter Plot" tabPanel  
      tabPanel("Modified Tooltip",
               mainPanel(plotlyOutput("tooltip"))
      ), # End "Modified Tooltip" tabPanel       
      tabPanel("Bar Chart",
               mainPanel(plotlyOutput("bars"))
      ) # End "Bar Chart" tabPanel       
    ) # End tabsetPanel
  ) # fluidPage
) # shinyUI
