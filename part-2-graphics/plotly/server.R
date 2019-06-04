library(readr)
assays <- read_csv("IC50_data.csv")

shinyServer(function(input, output, session) {
  output$scatter <- renderPlotly({
    p <- ggplot(data = assays, aes(x = Single_Point, y = Dose_Response, color = Target)) +
      geom_smooth(se = FALSE) + 
      geom_point(aes(text = paste("Compound:", Compound)), size = 4, alpha = .4) +
      scale_y_log10()
    ggplotly(p)
  }) ## output$scatter  
  
  output$conditioning <- renderPlotly({
    p <- ggplot(data = assays, aes(x = Single_Point, y = Dose_Response)) +
      geom_point(aes(text = paste("Compound:", Compound)), size = 4, alpha = .4) +
      geom_smooth(se = FALSE)+
      facet_wrap(~Target)
    scale_y_log10()
    ggplotly(p)
  }) ## output$conditioning  
  
  output$tooltip <- renderPlotly({
    p <- ggplot(data = assays, aes(x = Single_Point, y = Dose_Response)) +
      geom_point(aes(text = paste("Compound:", Compound)), size = 4, alpha = .4) +
      facet_wrap(~Target) + 
      scale_y_log10()
    ggplotly(p)
  }) ## output$tooltip    
    
    output$bars <- renderPlotly({
      p <- ggplot(data = assays, aes(x = Target)) + geom_bar()
      ggplotly(p)
    }) ## output$bars  
}) # End Shiny Server

