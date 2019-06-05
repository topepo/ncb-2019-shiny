library(shiny)
library(ggplot2)

ui <-
  pageWithSidebar(
    headerPanel("The Roundtrip Example"),
    sidebarPanel(
      fileInput(
        'csv_file',
        'Choose CSV File',
        accept = c('text/csv',
                   'text/comma-separated-values,text/plain',
                   '.csv')
      ),
      tags$hr(),
      uiOutput("column_choice"),
      tags$hr(),
      checkboxInput(inputId = "log_scale", label = "Log Scale?", TRUE)
    ),
    # sidebarPanel
    mainPanel(
      textOutput("description"),
      tags$br(),
      plotOutput("histogram")
    ) # mainpanel
  ) # pageWithSidebar

server <-
  function(input, output) {
    get_data <- reactive({
      ## Before the user chooses a file, we make sure that nothing is produced...
      req(input$csv_file)
      read.csv(input$csv_file$datapath)
    }) # get_data
    
    get_col_names <- reactive({
      dat <- get_data()
      num_cols <- vapply(dat, is.numeric, logical(1))
      names(num_cols)[num_cols]
    }) # get_col_names
    
    output$column_choice <- renderUI({
      columns <- get_col_names()
      selectInput(inputId = "value_col",
                  label = "Analysis Column",
                  choices = unique(c("None Selected" = "", columns)))
    }) # column_choice
    
    output$histogram <- renderPlot({
      dat <- get_data()
      req(input$value_col)
      out <- ggplot(dat, aes_string(x = input$value_col)) +
        geom_histogram(alpha = .7, fill = "red", col = "white") + 
        theme_bw()
      if (input$log_scale) {
        out <- out + scale_x_log10()
      }
      out
    }) # histogram
    
    output$description <- renderText({
      req(input$value_col)
      dat <- get_data()
      dat <- dat[[input$value_col]]
      num_missing <- sum(is.na(dat))
      paste0(
        "For these data, there were ",
        sum(!is.na(dat)),
        " data points and ",
        ifelse(num_missing == 0, " no ", num_missing),
        " missing values."
      )
    }) # description
    
  } # function

shinyApp(ui, server)
