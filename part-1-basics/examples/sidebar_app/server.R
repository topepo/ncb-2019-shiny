library(shiny)
library(ggplot2)
data(mpg)

shinyServer(
  function(input, output) {
    output$that_plot <- renderPlot(
      ggplot(mpg, aes(x = displ, y = cty)) + 
        geom_point() + theme_bw() +
        geom_smooth(method = loess, span = input$span)
    )
  }
)