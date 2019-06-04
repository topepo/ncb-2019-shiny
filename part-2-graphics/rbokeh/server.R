load("assays.RData")

## Set the default ggplot theme upfront
theme_set(theme_bw())

shinyServer(function(input, output, session) {
  output$orig_scatter <- renderPlot({
    ggplot(data = assays, aes(x = Single_Point, y = Dose_Response, color = Assay)) +
      geom_point(size = 4, alpha = .4) +
      geom_smooth(se = FALSE) +  scale_y_log10()
  }) ## output$orig_scatter  
  
  output$new_scatter <- renderRbokeh({
    p <- figure() %>% 
      ly_points(x = Single_Point, 
                y = Dose_Response, 
                data = assays, 
                color = Assay, hover = Compound) %>%
      y_axis(log = TRUE)
    p
  }) ## output$new_scatter  
  
  output$with_smoother <- renderRbokeh({
    
    inh_smooth <- with(subset(assays, Assay == "Inhibition"),
                       lowess(Dose_Response ~ Single_Point))
    unc_smooth <- with(subset(assays, Assay == "Uncoupling"),
                       lowess(Dose_Response ~ Single_Point))    
    p <- figure() %>% 
      ly_points(x = Single_Point, 
                y = Dose_Response, 
                data = assays, 
                color = Assay, hover = Compound)  %>%
      y_axis(log = TRUE)%>%
      ly_lines(inh_smooth, legend = "Inhibition", color = "blue")  %>%
      ly_lines(unc_smooth, legend = "Uncoupling", color = "orange") 
    
    p
  }) ## output$new_scatter    

}) # End Shiny Server

