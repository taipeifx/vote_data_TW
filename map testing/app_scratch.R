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
library(dplyr) 
library(tidyr)
library(readr)
tw <- readRDS("TWN_adm2.rds")
partylines <- read_csv('partylines_updated.txt')

########################################################## UI
ui <- navbarPage(
  title = 'Taiwan Votes',
  id = 'nav',
  theme = shinytheme('flatly'),
  
  ###################### MAPS tabPanel #############################   
tabPanel('Map of Taiwan',
         fluidRow(
           column(3,
                  h3('Interactive Map:'),
                  h4('Voter Stats'),
                  br(), #maybe put some explanatory things here
                  selectInput("ratio",
                              h4("Category"),
                              choices = c('KMT','DPP','New Party (1996)','Independent','Peoples First Party','Invalid Ballots','Voters that Voted'),
                              selected = 'KMT'),
                  selectInput("year3",
                              h4('By Year:'),
                              choices = unique(partylines$Year),
                              selected = '1996')),
           column(9, leafletOutput('statc'))
           
         ))
)

############################################ SERVER
server <- function(input, output) {
  ###################################################### map
  
  mapdata = reactive({

  pl2 = partylines 
  pl2 = filter(pl2, ANameE != "National", ANameE != "Taichung County", ANameE != "Tainan County", ANameE != "Kaohsiung County")
  pl2[pl2$ANameE == "New Taipei City",][1] = "Taipei County"  

#partylines #my data
#"ratio" = c('KMT','DPP','Invalid Ballots','Voters that Voted'),
    #independent, new party, peoples first?
#remove national
#choices = c('KMT','DPP','New Party (1996)','Independent','Peoples First Party','Invalid Ballots','Voters that Voted'),
      
 if (input$ratio=="KMT"){ #select by party
      mpdf = filter(pl2, Year == input$year3, Party == 'KMT') %>% # input from tabPanel('Map',
      select(ANameE, Value = Perc) %>% arrange(.$ANameE)
      
  }else if(input$ratio=="DPP"){ #select by party
      mpdf = filter(pl2, Year == input$year3, Party == 'DPP') %>%
      select(ANameE, Value = Perc) %>% arrange(.$ANameE)
      
  }else if(input$ratio=="New Party (1996)"){ #select by party
      mpdf = filter(pl2, Year == input$year3, Party == 'New Party') %>%
      select(ANameE, Value = Perc) %>% arrange(.$ANameE)
    
  }else if(input$ratio=="Independent"){ #select by party
      mpdf = filter(pl2, Year == input$year3, Party == 'z.Independent') %>%
      select(ANameE, Value = Perc) %>% arrange(.$ANameE)
    
  }else if(input$ratio=="Peoples First Party"){ #select by party
      mpdf = filter(pl2, Year == input$year3, Party == 'PeoplesFirstParty') %>%
      select(ANameE, Value = Perc) %>% arrange(.$ANameE)
      
  }else if(input$ratio=="Invalid Ballots"){#select unique
      mpdf = filter(pl2, Year == input$year3) %>%
      select(ANameE, Value = PercIB) %>% unique(.) %>% arrange(.$ANameE)
      
  }else if(input$ratio=="Voters that Voted"){ #select unique
      mpdf = filter(pl2, Year == input$year3) %>%
      select(ANameE, Value = PercAV) %>% unique(.) %>% arrange(.$ANameE)
  }
    
 mpdf$ratio= (mpdf$Value-min(mpdf$Value))/(max(mpdf$Value)-min(mpdf$Value)) #some range from 0 to 1
 
 mpdf  
 
})  
  
############################################################################## CALCULATION SCRATCH  
#    mpdf = filter(partylines, Year == 2000, ANameE != "National") %>%
#      select(ANameE, Value = PercIB) %>% unique(.)
#mpdf 
pl2 = partylines 
pl2 = filter(pl2, ANameE != "National", ANameE != "Taichung County", ANameE != "Tainan County", ANameE != "Kaohsiung County")
pl2[pl2$ANameE == "Taipei County",][1] = "New Taipei County"
pl2[pl2$ANameE == "Jinmen County",][1] = "Kinmen"  

    mpdf = filter(pl2, Year == 1996, Party == 'KMT') %>% # input from tabPanel('Map',
      select(ANameE, Value = Perc) %>% arrange(.$ANameE)
    b = filter(pl2, Year == 2016, Party == 'DPP') %>% # input from tabPanel('Map',
      select(ANameE, Value = Perc)%>% arrange(.$ANameE)
    c = filter(pl2, Year == 1996, Party == 'New Party') %>% # input from tabPanel('Map',
      select(ANameE, Value = Perc)%>% arrange(.$ANameE)
    d = filter(pl2, Year == 2016, Party == 'DPP') %>% # input from tabPanel('Map',
      select(ANameE, Value = Perc)%>% arrange(.$ANameE)
    e = filter(pl2, Year == 1996) %>% # input from tabPanel('Map',
      select(ANameE, Value = PercIB)%>% unique(.)%>% arrange(.$ANameE)
    f = filter(pl2, Year == 2012) %>% # input from tabPanel('Map',
      select(ANameE, Value = PercAV)%>% unique(.)%>% arrange(.$ANameE)
data.frame(a,b,c,d,e,f)
f
 mpdf

pl2 = partylines 

pl2 = filter(pl2, ANameE != "National", ANameE != "Taichung County", ANameE != "Tainan County", ANameE != "Kaohsiung County")
  
# ANameE          Value
# <chr>           <dbl>
# 1 Taipei City      21.7
# 2 Kaohsiung City   23.8

#    City Value
#    1 Changhua County  55.9
#    2     Chiayi City  58.3    
############################################################################## END OF CALCULATION SCRATCH  

output$statc = renderLeaflet({
    
    x <- mapdata()$ratio #from mapdata = reactive({
  
    x = mpdf$ratio # test, returns ratios
    
    rnk = c(9,10,4,7,13,16,17,18,20,1,2,3,5,6,8,11,12,14,15,19,21,22)
    
    x <- x[rnk] #rerank mpdf according to order of rds file district names .... 
    
    fillColor <- colorRampPalette(c('white', 'darkblue'))(length(x))[rank(x)]
    fillColor
    leaflet(data = tw) %>% addTiles() %>% setView(lng = 120.9605, lat = 23.6978, zoom = 7) %>%
      addPolygons(fillColor = fillColor, stroke = FALSE, fillOpacity = .6) #color filled based on ratio
})
  

}

# Run the application 
shinyApp(ui = ui, server = server)



###############################################################
newhppop = merge(newhp, newpop, by=c('City','Year'))
head(newhppop)



 
# observe({
#    print(mapdata())
#  })

output$statc = renderLeaflet({
  x <- mapdata()$ratio #from mapdata = reactive({
  x = mpdf$ratio #returns ratios
  
  
  print(mpdf$ANameE[rank]) #city names
  print(tw$NAME_2) #this is where the rds file is used, name2 is english names
  rank = c(9,10,4,7,13,16,17,18,20,1,2,3,5,6,8,11,12,14,15,19,21,22 )
  
  > print(mpdf$ANameE) #city names
  [1] "Changhua County"   "Chiayi City"       "Chiayi County"     "Hsinchu City"      "Hsinchu County"    "Hualien County"    "Kaohsiung City"    "Keelung City"     
  [9] "Kinmen"            "Lianjiang County"  "Miaoli County"     "Nantou County"     "New Taipei County" "Penghu County"     "Pingtung County"   "Taichung City"    
  [17] "Tainan City"       "Taipei City"       "Taitung County"    "Taoyuan County"    "Yilan County"      "Yunlin County"    
  
  > print(tw$NAME_2) #this is where the rds file is used, name2 is english names
  [1] "Kinmen" 9                   "Lienkiang (Matsu Islands)"10  "Hsinchu City" 4            "Kaohsiung"  7               "New Taipei City" 13           "Taichung" 16                
  [7] "Tainan" 17                   "Taipei"   18                 "Taoyuan" 20                  "Changhua" 1                 "Chiayi City"   2            "Chiayi County"3            
  [13] "Hsinchu County" 5           "Hualien" 6                  "Keelung"    8               "Miaoli"  11                  "Nantou"   12                 "Penghu"  14                 
  [19] "Pingtung"  15                "Taitung" 19                 "Yilan"  21                   "Yulin" 22              
  
  rnk <- c(10,11,12,3,13,14,4,15,1,2,16,17,5,18,19,6,7,8,20,9,21,22)

  
  x <- x[rank]
  x #rerank mpdf according to rds file district names .... 
  fillColor <- colorRampPalette(c('white', 'darkblue'))(length(x))
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

############################################################### BASIC VERSION
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



############################################################### END OF BASIC VERSION