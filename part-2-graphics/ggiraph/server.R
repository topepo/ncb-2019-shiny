library(ggplot2)
library(readr)
assays <- read_csv("IC50_data.csv")

## Set the default ggplot theme upfront
theme_set(theme_bw())

shinyServer(function(input, output, session) {
  output$orig_scatter <- renderPlot({
    ggplot(data = assays, aes(x = Single_Point, y = Dose_Response, color = Target)) +
      geom_point(size = 4, alpha = .4) +
      geom_smooth(se = FALSE) +  scale_y_log10()
  }) ## output$orig_scatter  
  
  output$new_scatter <- renderggiraph({
    p <- ggplot(data = assays, aes(x = Single_Point, y = Dose_Response, color = Target)) +
      geom_point_interactive(aes(tooltip = Compound), size = 4, alpha = .4) + 
      geom_smooth(se = FALSE) +  scale_y_log10()
    ggiraph(ggobj = p, width = 1)
  }) ## output$new_scatter  

}) # End Shiny Server

