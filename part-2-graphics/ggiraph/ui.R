library(ggiraph)

shinyUI(
  fluidPage(
    ## you will need this one extra line:
    tags$script("var state = null;"),
    tabsetPanel(
      tabPanel("Scatter Plot",
               mainPanel(
                 p("ggplot:"),
                 plotOutput("orig_scatter"),
                 br(),
                 p("ggiraph:"),
                 ggiraphOutput("new_scatter")
               )
      ) # End "Scatter Plot" tabPanel
    ) # End tabsetPanel
  ) # fluidPage
) # shinyUI
