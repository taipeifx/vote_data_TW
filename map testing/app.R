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
    leaflet(data = ) %>% addTiles() %>% setView(lng = 120.9605, lat = 23.6978, zoom = 7)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)



###############################################################
library(dplyr) 
library(tidyr)

newhp = read.csv('newhp.csv',header = T)
pop = read.csv('pop.csv',header = T)

newpop = gather(pop, Year, Population, -X) %>% rename(City = X) %>% 
  mutate( Year= sub("X", "", Year))
  
head(newpop)
#X  Year Population
#1 New Taipei City X2006    3767095
#2     Taipei City X2006    2632242

#       City    Year     Population
#1 New Taipei City 2006    3767095
#2     Taipei City 2006    2632242


newhppop = merge(newhp, newpop, by=c('City','Year'))


#data for map
trans = newhppop %>% filter(Year==2006) %>% select(., City)
head(trans)
#City
#1 Changhua County
#2     Chiayi City

mapdata = reactive({
#  if (input$ratio=="Gb_ratio"){
    mpdf = filter(newhppop, Year == 2006) %>% # input from tabPanel('Map',
      select(City, Value=Gb_ratio)
head(mpdf)
#City Value
#1 Changhua County  59.5
#2     Chiayi City  68.7

 #    }else if(input$ratio=="Sb_ratio"){
    mpdf = filter(newhppop, Year == 2006) %>%
      select(City, Value=Sb_ratio)
  #}
#    City Value
#    1 Changhua County  55.9
#    2     Chiayi City  58.3
    
  # colnames(mpdf)[2]='Value'
  mpdf$ratio= (mpdf$Value-min(mpdf$Value))/(max(mpdf$Value)-min(mpdf$Value)) #some range from 0 to 1
  # row.names(mpdf) = trans[mpdf$City, 'COUNTYNAME']
  mpdf
})

 
# observe({
#    print(mapdata())
#  })

output$statc = renderLeaflet({
  x <- mapdata()$ratio #from mapdata = reactive({
  x = mpdf$ratio #returns ratios
  
  
  print(mpdf$City) #city names
  print(tw$NAME_2) #this is where the rds file is used, name2 is english names
  rnk <- c(10,11,12,3,13,14,4,15,1,2,16,17,5,18,19,6,7,8,20,9,21,22)
  x <- x[rnk]
  x #rerank mpdf according to rds file district names .... 
  fillColor <- colorRampPalette(c('white', 'darkblue'))(length(x))[rank(x)]
  leaflet(data = tw) %>% addTiles() %>% setView(lng = 120.9605, lat = 23.6978, zoom = 7) %>%
    addPolygons(fillColor = fillColor, stroke = FALSE, fillOpacity = .6) #color filled based on ratio
})

length(x)
rank(x)
x
# output$statc = renderLeaflet({
#   
#   geojson <- readLines(geo.json.url, warn = FALSE) %>%
#     paste(collapse = "\n") %>%
#     fromJSON(simplifyVector = FALSE)
#   
#   geojson$style = list(
#     weight = 1,
#     color = "#444444",
#     opacity = 1,
#     fillOpacity = 0.8
#   )
#   #pal <- colorQuantile("Greens", data$ratio)
#   pal <- colorNumeric(c("white","darkblue"), mapdata()$ratio)
#   
#   geojson$features <- lapply(geojson$features, function(feat) {
#     feat$properties$style <- list(
#       fillColor = pal(
#         mapdata()[feat$properties$COUNTYNAME, 'ratio']
#       )
#     )
#     feat
#   })
# 
#   leaflet() %>% setView(lng = 121, lat = 23.5, zoom = 6) %>% 
#     addTiles() %>% addGeoJSON(geojson, fillColor = T)
# })




}