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
library(leaflet)
library(dplyr) 
library(tidyr)
library(readr)
tw <- readRDS("TWN_adm2.rds")
partylines <- read_csv('partylines_updated.txt')
pl2 = partylines 
pl2 = filter(pl2, ANameE != "National", ANameE != "Taichung County", ANameE != "Tainan County", ANameE != "Kaohsiung County")
pl2[pl2$ANameE == "New Taipei City",][1] = "Taipei County" 

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
    
    mpdf$ratio= (mpdf$Value-min(mpdf$Value))/(max(mpdf$Value)-min(mpdf$Value)) #some range from 0 to 1
    
    mpdf  
  })  
  
  output$statc = renderLeaflet({
    print(mapdata())
    x <- mapdata()$ratio #from mapdata = reactive({
    
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