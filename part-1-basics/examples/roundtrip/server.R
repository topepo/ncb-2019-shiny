library(shiny)
library(ggplot2)

check_input <- function(x) !is.null(x) && x != "None Selected"

shinyServer(
  function(input, output) {
    
    get_data <- reactive({
      ## Before the user chooses a file, we make sure that nothing is produced...
      if (is.null(input$csv_file)) return(NULL) 
      read.csv(input$csv_file$datapath)
    }) # get_data
    
    get_col_names <- reactive({
      dat <- get_data()
      if (is.null(dat)) return(NULL) 
      num_cols <- unlist(lapply(dat, function(x) is.numeric(x)))
      names(num_cols)[num_cols]
    }) # get_col_names
    
    output$value_choice <- renderUI({
      columns <- get_col_names()
      if(is.null(columns)) return(NULL) else 
        selectInput(inputId = "value_col", 
                    label = "Analysis Column", 
                    choices = unique(c("None Selected", columns)))
    }) # value_choice 
    
    output$histogram <- renderPlot({
      dat <- get_data()
      if (is.null(dat) | !check_input(input$value_col)) return(NULL) 
      out <- ggplot(dat, aes_string(x = input$value_col)) + 
        geom_histogram(alpha = .7, fill = "red", col = "red") + theme_bw()
      if(input$log_it == "Yes") out <- out + scale_x_log10()
      out
    }) # histogram     
    
    output$description <- renderText({
      dat <- get_data()
      if (is.null(dat) | !check_input(input$value_col)) return(NULL) 
      dat <- dat[, input$value_col]
      num_missing <- sum(is.na(dat))
      paste0("For these data, there were ", sum(!is.na(dat)),
             " data points and ", ifelse(num_missing == 0, " no ", num_missing),
             " missing values.")
    }) # description         
 
  } # function
) # shinyServer