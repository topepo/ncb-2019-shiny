library(shiny)
library(ggplot2)

ui_part <- 
  fluidPage(
    plotOutput("that_plot") # grab an output element with this name
  )

server_part <- function(input, output) {
  ## The output name ("that_plot")` matches the inuput above
  output$that_plot <- renderPlot(
    ggplot(mpg, aes(x = displ, y = cty)) +  geom_point() + theme_bw() 
  )
}

shinyApp(ui = ui_part, server = server_part)

