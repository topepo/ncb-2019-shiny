library(shiny)
library(ggplot2)
library(readr)
library(recipes)
library(heatmaply)
library(shinyBS)

options(shiny.maxRequestSize = 50 * 1024 ^ 2)

ui <-
  pageWithSidebar(
    headerPanel("Multivariate Plots"),
    sidebarPanel(
      fileInput(
        'csv_file',
        'Choose CSV File',
        accept = c('text/csv',
                   'text/comma-separated-values,text/plain',
                   '.csv')
      ),
      tags$hr(),
      checkboxInput(inputId = "bc_trans", label = "Symmetry Transform?", TRUE),
      tags$hr(),
      checkboxInput(inputId = "nzv", label = "Remove Near Zero-Variance Columns", TRUE)
    ),
    # sidebarPanel
    mainPanel(
      bsCollapse(
        bsCollapsePanel(
          title = "Principal Component Analysis",
          style = "primary",
          plotOutput("pca")
        ),
        bsCollapsePanel(
          title = "Correlation Matrix Heatmap",
          style = "info",
          plotlyOutput("heatmap", width = "100%", height = "500px")
        )
      ) # bsCollapse
    ) # mainpanel
  ) # pageWithSidebar

server <-
  function(input, output) {

    data_recipe <- reactive({
      req(input$csv_file)
      dat <- read_csv(input$csv_file$datapath)
      num_cols <- vapply(dat, is.numeric, logical(1))
      num_cols <- names(num_cols)[num_cols]
      dat <- dat[, num_cols]
      dat <- dat[complete.cases(dat), ]

      rec <- recipe(~ ., data = dat)
      if (input$nzv) {
        rec <- rec %>% step_nzv(all_predictors())
      } else {
        rec <- rec %>% step_zv(all_predictors())
      }
      if (input$bc_trans) {
        rec <- rec %>% step_YeoJohnson(all_predictors())
      }
      rec <-
        rec %>%
        step_center(all_predictors()) %>%
        step_scale(all_predictors())  %>%
        prep()
      rec
    }) # data_recipe

    pca_recipe <- reactive({
      req(input$csv_file)
      rec <- data_recipe()
      rec <- rec %>%
        step_pca(all_predictors()) %>%
        prep()
    }) # pca_recipe


    output$pca <- renderPlot({
      req(input$csv_file)
      pca_rec <- pca_recipe()

      pca_values <- juice(pca_rec)

      steps <- length(pca_rec$steps)
      sdev <- pca_rec$steps[[steps]]$res$sdev
      pct <- (sdev ^ 2) / sum(sdev ^ 2) * 100

      nms <- names(pca_values)[1:2]
      labs <- paste0(nms, " (", round(pct, 0), "%)")

      rngs <- extendrange(c(pca_values[[1]], pca_values[[2]]))

      out <-
        ggplot(pca_values, aes_string(x = nms[1], y = nms[2])) +
        geom_point(alpha = .3) +
        theme_bw() +
        xlim(rngs) +
        ylim(rngs) +
        xlab(labs[1]) +
        ylab(labs[2]) +
        coord_equal()
      out
    }) # pca


    output$heatmap <- renderPlotly({
      req(input$csv_file)
      rec <- data_recipe()
      corr_mat <- cor(juice(rec), use = "pairwise.complete.obs")
      heatmaply_cor(
        corr_mat,
        colors = BrBG,
        symm = TRUE,
        showticklabels = c(FALSE, FALSE),
        branches_lwd = .2,
        margins = c(10, 10),
        width = 500,
        height = 500
      )
    }) # heatmap




  } # function

shinyApp(ui, server)
