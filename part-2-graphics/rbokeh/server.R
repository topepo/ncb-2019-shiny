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
  
  output$new_scatter <- renderRbokeh({
    p <- figure() %>% 
      ly_points(x = Single_Point, 
                y = Dose_Response, 
                data = assays, 
                color = Target, hover = Compound) %>%
      y_axis(log = TRUE)
    p
  }) ## output$new_scatter  
  
  output$with_smoother <- renderRbokeh({
    
    inh_smooth <- with(subset(assays, Target == "A"),
                       lowess(Dose_Response ~ Single_Point))
    unc_smooth <- with(subset(assays, Target == "B"),
                       lowess(Dose_Response ~ Single_Point))    
    p <- figure() %>% 
      ly_points(x = Single_Point, 
                y = Dose_Response, 
                data = assays, 
                color = Target, hover = Compound)  %>%
      y_axis(log = TRUE) %>%
      ly_lines(inh_smooth, legend = "A", color = "blue")  %>%
      ly_lines(unc_smooth, legend = "B", color = "orange") 
    
    p
  }) ## output$new_scatter    

}) # End Shiny Server

