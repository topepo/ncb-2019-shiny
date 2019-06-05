library(shiny)
library(ggplot2)
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

p <- ggplot(data = assays,
            aes(x = Single_Point,
                y = Dose_Response,
                color = Target)) +
  geom_point(size = 4, alpha = .4) +
  geom_smooth(se = FALSE) +
  scale_y_log10()

ui <- fluidPage(
  # Exposes hover info on the server as `input$hover`
  # Can also do this with click or brush
  plotOutput("plot", hover = "hover"),
  tableOutput("table")
)
server <- function(input, output, session) {
  output$plot <- renderPlot(p)
  output$table <- renderTable(nearPoints(assays, input$hover))
}
shinyApp(ui, server)

