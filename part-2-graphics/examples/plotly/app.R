library(shiny)
library(ggplot2)
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


ui <- fluidPage(
  plotlyOutput("plot"),
  tableOutput("table")
)

server <- function(input, output, session) {
  output$plot <- renderPlotly({
    p <- ggplot(assays, aes(x = Single_Point, y = Dose_Response, color = Target)) +
      geom_point(aes(text = Compound, customdata = Compound), size = 4, alpha = .4) +
      geom_smooth(se = FALSE) +  
      scale_y_log10()
    ggplotly(p, tooltip = "text")
  })
  # event_data() function can be used to access information about all sorts of events
  output$table <- renderTable({
    hovered_compound <- event_data("plotly_hover")$customdata
    filter(assays, Compound %in% hovered_compound)
  })
}

shinyApp(ui, server)
