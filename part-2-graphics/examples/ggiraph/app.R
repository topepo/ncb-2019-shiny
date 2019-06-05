library(shiny)
library(ggiraph)
library(plotly)
library(readr)

assays <- read_csv("https://raw.githubusercontent.com/topepo/ncb-2019-shiny/master/data/IC50_data.csv")

thm <- theme_bw() + 
  theme(
    panel.background = element_rect(fill = "transparent", colour = NA), 
    plot.background = element_rect(fill = "transparent", colour = NA),
    legend.position = "top",
    legend.background = element_rect(fill = "transparent", colour = NA),
    legend.key = element_rect(fill = "transparent", colour = NA)
  )
theme_set(thm)


ggiraph_ggplot <- 
  ggplot(assays, aes(x = Single_Point, y = Dose_Response, color = Target)) +
  geom_point_interactive(aes(tooltip = Compound, data_id = Compound), size = 4, alpha = .4) +
  geom_smooth(se = FALSE) + scale_y_log10()

ui <- fluidPage(
  girafeOutput("plot"),
  tableOutput("table")
)

server <- function(input, output, session) {
  output$plot <- renderGirafe({
    ggiraph(
      ggobj = ggiraph_ggplot, 
      hover_css = "fill:red;cursor:pointer;",
      selection_type = "single",
      selected_css = "fill:red;"
    )
  })
  output$table <- renderTable(filter(assays, Compound %in% input$plot_selected))
}

shinyApp(ui, server)
