#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
tw <- readRDS("TWN_adm2.rds")
# Define UI for application that draws a histogram
ui <- fluidPage(
           fluidRow(
             leafletOutput('statc')
           )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  ###################################################### map
  output$statc = renderLeaflet({
    leaflet(data = tw) %>% addTiles() %>% setView(lng = 120.9605, lat = 23.6978, zoom = 7)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

