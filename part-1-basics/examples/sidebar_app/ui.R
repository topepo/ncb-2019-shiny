library(shiny)
shinyUI(
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        sliderInput("span", "Smoother Span:",  
                    min = .2, max = 1, step = .05, value = .8)
      ), # sidebarPanel
      mainPanel(plotOutput("that_plot"))
    ) # sidebarLayout
  ) # fluidPage
) # shinyUI
