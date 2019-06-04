library(rbokeh)
library(ggplot2)
library(htmlwidgets)

shinyUI(
  fluidPage(
    ## you will need this one extra line:
    tags$script("var state = null;"),
    tabsetPanel(
      tabPanel("Scatter Plot",
               mainPanel(
                 p("ggplot2:"),
                 plotOutput("orig_scatter"),
                 br(),
                 p("rbokeh:"),
                 rbokehOutput("new_scatter"),
                 br(),
                 p("rbokeh with smoother:"),
                 rbokehOutput("with_smoother")
               )
      ) # End "Scatter Plot" tabPanel
    ) # End tabsetPanel
  ) # fluidPage
) # shinyUI
