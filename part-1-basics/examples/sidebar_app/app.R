library(shiny)
library(ggplot2)

ui <- 
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        sliderInput(inputId = "span", label = "Smoother Span:",  
                    min = .2, max = 1, value = .8)
      ), # sidebarPanel
      mainPanel(plotOutput("that_plot"))
    ) # sidebarLayout
  ) # fluidPage

server <- 
  function(input, output) {
    output$that_plot <- renderPlot(
      ggplot(mpg, aes(x = displ, y = cty)) + 
        geom_point() + theme_bw() +
        geom_smooth(method = "loess", span = input$span)
    ) # that_plot
  } # function

shinyApp(ui, server)