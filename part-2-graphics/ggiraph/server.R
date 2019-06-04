load("assays.RData")
assays$hover <- as.character(assays$Compound)
assays$click <- paste0("function() {window.open('http://pronto.pfizer.com/pronto/?cmpdid=",
                       as.character(assays$Compound), "')}")

## Set the default ggplot theme upfront
theme_set(theme_bw())

shinyServer(function(input, output, session) {
  output$orig_scatter <- renderPlot({
    ggplot(data = assays, aes(x = Single_Point, y = Dose_Response, color = Assay)) +
      geom_point(size = 4, alpha = .4) +
      geom_smooth(se = FALSE) +  scale_y_log10()
  }) ## output$orig_scatter  
  
  output$new_scatter <- renderggiraph({
    p <- ggplot(data = assays, aes(x = Single_Point, y = Dose_Response, color = Assay)) +
      geom_point_interactive(aes(tooltip = hover, onclick = click), size = 4, alpha = .4) + 
      geom_smooth(se = FALSE) +  scale_y_log10()
    ggiraph(code = {print(p)}, width = 8, height = 5.5)
  }) ## output$new_scatter  

}) # End Shiny Server

