#INTERACTIVE MAP
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(leaflet)
library(dplyr) 
library(tidyr)
library(readr)
tw <- readRDS("TWN_adm2.rds")
partylines <- read_csv('partylines_updated.txt')
pl2 = partylines  #mapdata = reactive
pl2 = filter(pl2, ANameE != "National", ANameE != "Taichung County", ANameE != "Tainan County", ANameE != "Kaohsiung County") #mapdata = reactive
pl2[pl2$ANameE == "New Taipei City",][1] = "Taipei County" #mapdata = reactive

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
                                choices = c('KMT','DPP','New Party (1996, 2000)','Independent(1996, 2000)',
                                            'Peoples First Party (2012, 2016)','Invalid Ballots','Voters that Voted'),
                                selected = 'KMT'),
                    selectInput("year3",
                                h4('By Year:'),
                                choices = unique(partylines$Year),
                                selected = '1996')),
             column(9, leafletOutput('statc'))
             
           ))
  ###################### end MAPS tabPanel #############################  
)

############################################ SERVER
server <- function(input, output) {
  ###################################################### map
  
  mapdata = reactive({
    
    if (input$ratio=="KMT"){ #select by party
      mpdf = filter(pl2, Year == input$year3, Party == 'KMT') %>% # input from tabPanel('Map',
        select(ANameE, Value = Perc) %>% arrange(.$ANameE)
      
    }else if(input$ratio=="DPP"){ #select by party
      mpdf = filter(pl2, Year == input$year3, Party == 'DPP') %>%
        select(ANameE, Value = Perc) %>% arrange(.$ANameE)
      
    }else if(input$ratio=="New Party (1996, 2000)"){ #select by party
      mpdf = filter(pl2, Year == input$year3, Party == 'New Party') %>%
        select(ANameE, Value = Perc) %>% arrange(.$ANameE)
      
    }else if(input$ratio=="Independent(1996, 2000)"){ #select by party
      mpdf = filter(pl2, Year == input$year3, Party == 'z.Independent') %>%
        select(ANameE, Value = Perc) %>% arrange(.$ANameE)
      
    }else if(input$ratio=="Peoples First Party (2012, 2016)"){ #select by party
      mpdf = filter(pl2, Year == input$year3, Party == 'PeoplesFirstParty') %>%
        select(ANameE, Value = Perc) %>% arrange(.$ANameE)
      
    }else if(input$ratio=="Invalid Ballots"){#select unique
      mpdf = filter(pl2, Year == input$year3) %>%
        select(ANameE, Value = PercIB) %>% unique(.) %>% arrange(.$ANameE)
      
    }else if(input$ratio=="Voters that Voted"){ #select unique
      mpdf = filter(pl2, Year == input$year3) %>%
        select(ANameE, Value = PercAV) %>% unique(.) %>% arrange(.$ANameE)
    }
    
    #mpdf$ratio= (mpdf$Value-min(mpdf$Value))/(max(mpdf$Value)-min(mpdf$Value)) #some range from 0 to 1
    mpdf 
  })  
  
  output$statc = renderLeaflet({
    print(mapdata())
#################################################### MAP CALCULATIONS/INPUT    
    #rerank mpdf according to order of rds file district names
    rnk = c(7,10,4,8,18,15, 
            16,17,20,1,2,3,
            5,6,9,11,12,13,
            14,19,21,22)  

    pal <- colorBin("YlOrRd", domain = mapdata()$Value[rnk]) #color scheme and shade values
    
    labels = sprintf( #mouseover labels
      "<strong>%s</strong><br/>%g%%",
      tw$NAME_2, mapdata()$Value[rnk]
    ) %>% lapply(htmltools::HTML)
##################################################### PLOT MAP
    
    # https://rstudio.github.io/leaflet/choropleths.html
    leaflet(data = tw) %>% addProviderTiles(providers$Esri.WorldStreetMap) %>% setView(lng = 120.9605, lat = 23.6978, zoom = 7) %>%
      addPolygons(
      
      #fill colors according to rnk order & outline districs 
      fillColor = ~pal(mapdata()$Value[rnk]), weight = 2, opacity = 1,
      color = "white", dashArray = "3", fillOpacity = 0.7,
      
      #highlight on mouseover
      highlight = highlightOptions(weight = 5, color = "#666", dashArray = "", fillOpacity = 0.7, bringToFront = TRUE),
      
      #labels on mouseover
      label = labels, 
      labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "15px", direction = "auto")) %>% 
      
      #add minimap 
      addMiniMap(tiles = providers$Esri.WorldStreetMap, zoomLevelOffset = -4, width = 300, height = 300, position = 'bottomleft', toggleDisplay = TRUE)
  })
  ###################################################### end map
  
}

# Run the application 
shinyApp(ui = ui, server = server)



###############################################################