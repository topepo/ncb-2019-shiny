library(shiny)
library(ggplot2)
library(readr)
library(yardstick)

ui <-
  pageWithSidebar(
    headerPanel("ROC Curves"),
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
      checkboxInput(inputId = "log_scale", label = "Log Scale?", TRUE),
      tags$hr(),
      sliderInput(
        "quant_val",
        label = "Data Quantile",
        min = 0,
        max = 1,
        value = 0.5,
        step = 0.05
      )
    ),
    # sidebarPanel
    mainPanel(
      plotOutput("densities"),
      plotOutput("roc")
    ) # mainpanel
  ) # pageWithSidebar

server <-
  function(input, output) {
    get_data <- reactive({
      ## Before the user chooses a file, we make sure that nothing is produced...
      req(input$csv_file)
      read_csv(input$csv_file$datapath) %>%
        mutate(Class = factor(Class, levels = c("toxic", "nontoxic")))
    }) # get_data

    get_col_names <- reactive({
      dat <- get_data()
      num_cols <- vapply(dat, is.numeric, logical(1))
      names(num_cols)[num_cols]
    }) # get_col_names

    get_values <- reactive({
      req(input$value_col, input$log_scale)
      dat <- get_data()
      dat <- dat[[input$value_col]]
      dat <- dat[complete.cases(dat)]

      if (input$log_scale) {
        dat <- log10(dat)
      }

      c(min = min(dat), med = median(dat), max = max(dat))
    }) # get_values

    output$column_choice <- renderUI({
      columns <- get_col_names()
      selectInput(inputId = "value_col",
                  label = "Analysis Column",
                  choices = unique(c("None Selected" = "", columns)))
    }) # column_choice

    output$densities <- renderPlot({
      dat <- get_data()
      req(input$value_col, input$quant_val)

      x_val <- quantile(dat[[input$value_col]], prob = input$quant_val, na.rm = TRUE)

      out <- ggplot(dat, aes_string(x = input$value_col, col = "Class")) +
        geom_line(stat = "density") +
        theme_bw() +
        theme(legend.position = "top") +
        geom_vline(xintercept = x_val, col = "black")

      if (input$log_scale) {
        out <- out + scale_x_log10()
      }
      out
    }) # densities

    output$roc <- renderPlot({
      dat <- get_data()
      req(input$value_col, input$quant_val)

      dat$value <- dat[[input$value_col]]

      curve_dat <- roc_curve(dat, Class, value)

      x_val <- quantile(dat$value, prob = input$quant_val, na.rm = TRUE)

      curve_dist <- (x_val - curve_dat$.threshold)^2
      nearest <- which.min(curve_dist)
      ref_point <- curve_dat[nearest,]

      out <- autoplot(curve_dat) +
        geom_point(data = ref_point, aes(x = 1 - specificity, y = sensitivity),
                   pch = 16, col = "red", cex = 4) +
        theme_bw() +
        theme(legend.position = "top")

      out
    }) # roc

  } # function

shinyApp(ui, server)
