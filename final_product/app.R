# Chart App 1 Select Regions based on Year &
# Chart App 2 Select Years by Region &
# INTERACTIVE MAP
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
################################################

library(shiny)
library(shinythemes)
library(dplyr)
library(reshape2)#dcast
library(googleVis)
library(readr)
library(tidyr)
library(leaflet)
library(shinydashboard)
library(markdown)
##########################data for shiny app
#for chart apps
partylines = read_csv('partylines_updated.txt')
candinfo = read.csv('candinfo2.txt',check.names=FALSE)

#for interactive maps
tw <- readRDS("TWN_adm2.rds")
pl2 = partylines  #mapdata = reactive
pl2 = filter(pl2, ANameE != "National", ANameE != "Taichung County", ANameE != "Tainan County", ANameE != "Kaohsiung County") #mapdata = reactive
pl2[pl2$ANameE == "New Taipei City",][1] = "Taipei County" #mapdata = reactive
########################## end data for shiny app

##################################################################################################### Define UI
ui <-  navbarPage(
  title = 'Taiwan Votes',
  id = 'nav',
  theme = shinytheme('flatly'),
  
  ###################### CHART APP 1 tabPanel #############################    
  tabPanel('Charts: Select Regions',
           fluidRow(
             column(3,
                    h3('Interactive Chart:'),
                    h4('Compare Regions By Year'),
                    br(),
                    br(),
                    selectizeInput("city",
                                   h4("Select Region"),
                                   choices = unique(partylines$ANameE),
                                   selected = c('Taipei City'), #,'Taichung City','Tainan City'),
                                   multiple = TRUE
                    ),
                    br(),
                    selectInput("category",
                                h4("By Category"),
                                choices = c('Vote Count', '% of Votes (%)', 'Total Voters', 
                                            'Invalid Ballots (%)', "Eligible Voters that Voted (%)"),
                                selected = 'Vote Count'
                    ),
                    selectInput("year",
                                h4('By Year:'),
                                choices = unique(partylines$Year),
                                selected = '2006'
                    )
             ),
             column(9, htmlOutput('charta')),
             
             #Candidate Info
             column(10, h3("Candidate Info"),
                    tableOutput("table"))
           )),
  
  ###################### CHART APP 2 tabPanel #############################    
  tabPanel('Charts: Select Years',
           fluidRow(
             column(3,
                    h3('Interactive Chart:'),
                    h4('Compare Years By Region'),
                    br(),
                    br(),
                    selectizeInput("year2",
                                   h4("Select Year(s)"),
                                   choices = unique(partylines$Year), 
                                   selected = c('1996'),
                                   multiple = TRUE
                    ),
                    br(),
                    selectInput("category2",
                                h4("By Category"),
                                choices = c('Vote Count', '% of Votes (%)', 'Total Voters', 
                                            'Invalid Ballots (%)', "Eligible Voters that Voted (%)"),
                                selected = 'Vote Count'
                    ),
                    selectInput("city2",
                                h4('By Area:'),
                                choices = unique(partylines$ANameE),
                                selected = 'Taipei City' #,'Taichung City','Tainan City'),
                    )
             ),
             column(9, htmlOutput('charta2')),
             
             #Candidate Info
             column(12, h3("Candidate Info"),
                    tableOutput("table2"))
           )),
  
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
             column(9, leafletOutput("statc",height = 600))
             )
             
           ),
  ###################### end MAPS tabPanel #############################  
  ############################################################# Stats Panel 
  tabPanel('Stats',
           fluidRow(
             column(12, includeHTML("Taiwan Vote Project in R Shiny.html"),
                    br())
           )
           
  ),
  ############################################################# About 
  tabPanel('Project Info',
           fluidRow(
             column(12,dashboardPage(dashboardHeader(disable = T),
                                     dashboardSidebar(disable = T),
                                     dashboardBody(br(),br(),br(),br(),br(),
                    h2('New York City Data Science Academy'),
                    h3('Fall Cohort 2018'),
                    h4('Raw Data from'),
                    tags$div(class = 'header', checked = NA,
                             tags$a(href = 'https://data.gov.tw/','https://data.gov.tw/')),
                    h4('Explanation on Data from'),
                    tags$div(class = 'header', checked = NA,
                             tags$a(href = 'https://github.com/MISNUK/CECDataSet/blob/master/RawData_Format.md','MISNUK GitHub' )),
                    h4('Created by'), 
                    tags$div(class = "header", checked = NA,
                             tags$p("Daniel Chen : dchen@taipeifx.com"),
                             tags$div(class = "header", checked = NA,
                                      tags$a(href= "https://github.com/taipeifx/vote_data_TW","TaipeiFX GitHub")),
                             tags$div(class = "header", checked = NA,
                                      tags$a(href= "https://nycdsa.com","NYCDSA Blog"))
                             ))
                    ))
             ))
  ############################################################# End About   
  
)
###################################################################################################### End Define UI


###################################################################################################### Define Server Logic
server <- function(input, output) {
  
  # SELECTION #('Vote Count', '% of Votes (%)', 'Total Pop', 'Total Voters', 'Invalid Ballots (%)', "Eligible Voters that Voted (%)")
  
  ###################### CHART APP 1 SERVER SELECTIONS ############################# 
  VP = reactive({ #if else based on category selection
    if (input$category == 'Vote Count'){
      xx= "Votes"} else {
        if (input$category == '% of Votes (%)'){
          xx = "Perc"}
      }
    return(xx)
  })   
  
  VP2 = reactive({ #if else based on category , these need unique values
    #('Vote Count', '% of Votes (%)', 'Total Pop', 'Total Voters', 'Invalid Ballots (%)', "Eligible Voters that Voted (%)")
        if (input$category == 'Total Voters'){
          xx = "TotalVote"} else {
            if (input$category == 'Invalid Ballots (%)'){
              xx = "PercIB"} else {
                if (input$category == 'Eligible Voters that Voted (%)'){
                  xx = "PercAV"}
              }
          }
    return(xx)
  })
  
  #####charts based on SELECTION #
  
  v_chart = reactive({ #v_chart returns tt
    tt = filter(partylines, Year == input$year & ANameE %in% input$city) %>% #based on selection Year, ANameE, Party + Votes
      select(ANameE, Party, sprintf("%s", VP()))
    ttname= names(tt)   #ttname returns column headers
    tt= tt %>% dcast(as.formula(paste(ttname[1:2], collapse ='~')), value.var = ttname[3]  ) # 1 row with each party as a column header
    return(tt) 
  })
  
  v_chart2 = reactive({ #v_chart returns zz
    zz = filter(partylines, Year == input$year & ANameE %in% input$city) %>% #based on selection Year, ANameE, Party + Votes
      select(ANameE, sprintf("%s", VP2()))
    zz= unique(zz)
    #zz$ANameE = as.factor(zz$ANameE) #?
    return(zz) 
  })
  
  output$charta = renderGvis({
    #print (names(v_chart())[-1]) #debug purposes
    
    if (input$category == 'Vote Count' | input$category == '% of Votes (%)'){    
      g1 = gvisBarChart(v_chart(), "ANameE", names(v_chart())[-1], #bar chart (data, ANameE, party names)
                        options = list(colors= "['#00e600','#0000EE', '#FFFF00', '#ffa500', '#EE3B3B']",
                                       legend="right",
                                       bar="{groupWidth:'90%'}",gvis.editor="Make a change?",
                                       width=800,height=500))} else{
                                         
                                         if (input$category == 'Total Voters' | input$category == 'Invalid Ballots (%)' | 
                                             input$category == 'Eligible Voters that Voted (%)'){
                                           g1 = gvisBarChart(v_chart2(),
                                                             options = list(legend="right",
                                                                            bar="{groupWidth:'90%'}",gvis.editor="Make a change?",
                                                                            width=800,height=500))}
                                       }
    
    g1
  })
  
  #Candidate Info  
  toppings <- reactive({
    a = input$year
    b = candinfo[a][[1]]
    return (b)
  })
  
  output$table <- renderTable({
    sprintf("%s", toppings()) #(candinfo[input$year][[1]]) #debug purposes
    #print (unique(partylines$Year))
  })
  ###################### CHART APP 1 SERVER SELECTIONS END ############################# 
  
  ###################### CHART APP 2 SERVER SELECTIONS ############################# 
  # SELECTION #('Vote Count', '% of Votes (%)', 'Total Pop', 'Total Voters', 'Invalid Ballots (%)', "Eligible Voters that Voted (%)")
  WP = reactive({ #if else based on category selection
    if (input$category2 == 'Vote Count'){
      xx= "Votes"} else {
        if (input$category2 == '% of Votes (%)'){
          xx = "Perc"}
      }
    return(xx)
  })   
  
  WP2 = reactive({ #if else based on category , these need unique values
    #('Vote Count', '% of Votes (%)', 'Total Pop', 'Total Voters', 'Invalid Ballots (%)', "Eligible Voters that Voted (%)")
        if (input$category2 == 'Total Voters'){
          xx = "TotalVote"} else {
            if (input$category2 == 'Invalid Ballots (%)'){
              xx = "PercIB"} else {
                if (input$category2 == 'Eligible Voters that Voted (%)'){
                  xx = "PercAV"}
              }
          }
    return(xx)
  })     
  
  #charts based on SELECTION #
  
  w_chart = reactive({ #w_chart returns xx, input from WP
    tt2 = filter(partylines, ANameE == input$city2 & Year %in% input$year2) %>% #based on selection ANameE, Year, Party + Votes
      select("Year", "Party", sprintf("%s", WP())) #input for votes or percentage? VP = Votes or Perc
    ttname2= names(tt2)   #ttname returns column headers
    tt2= tt2 %>% dcast(as.formula(paste(ttname2[1:2], collapse ='~')), value.var = ttname2[3]  ) # 1 row with year, each party as a column header
    return(tt2) 
  })
  
  w_chart2 = reactive({ #v_chart returns zz, input from VP2
    zz2 = filter(partylines, ANameE == input$city2 & Year %in% input$year2) %>% #based on selection ANameE, Year, Party + Votes
      select("Year", sprintf("%s", WP2())) #input for TotalPop, TotalVote, PercIB, PercAV
    zz2 = unique(zz2)  #
    zz2$Year = as.factor(zz2$Year)
    
    zz2$Mean = mean(zz2[[sprintf("%s", WP2())]]) #add column 'mean' for plotting a line

    return(zz2) 
  })

  output$charta2 = renderGvis({
    #print (names(v_chart())[-1]) #debug purposes
    if (input$category2 == 'Vote Count' | input$category2 == '% of Votes (%)'){
      g2 = gvisColumnChart(w_chart(), "Year", names(w_chart())[-1], #column chart (data, ANameE, party names), these are names of columns in the data file
                           options = list(colors= "['#00e600','#0000EE', '#FFFF00', '#ffa500', '#EE3B3B', '#FF00FF']",
                                          legend="right",
                                          bar="{groupWidth:'90%'}",gvis.editor="Make a change?",
                                          width=800,height=500))} else{
                                            
                                            if (input$category2 == 'Total Voters' | input$category2 == 'Invalid Ballots (%)' | input$category2 == 'Eligible Voters that Voted (%)'){
                                              g2 = gvisComboChart(w_chart2(), 
                                                                   options = list(seriesType = "bars",                            
                                                                                  series="{1:{type:'line', 
                                                                                          lineWidth: 10,
                                                                                          color:'black'}}",
                                                                                  legend="right",
                                                                                  bar="{groupWidth:'90%'}",gvis.editor="Make a change?",
                                                                                  width=800,height=500))}
                                          }
    
    g2
  })
  
  #Candidate Info  
  toppings2 <- reactive({
    a = levels(transform(input$year2)[[1]])
    b = candinfo[a]
    return (data.frame(b,check.names = F))
  })  
  
  output$table2 <- renderTable({  
    toppings2()  
  }) 
  ###################### CHART APP 2 SERVER SELECTIONS END ############################# 
  
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
    #print(mapdata())
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
    leaflet(data = tw) %>% addProviderTiles(providers$Esri.WorldStreetMap) %>% setView(lng = 120, lat = 23.7, zoom = 7) %>%
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
###################################################################################################### End Define Server Logic

# Run the application 

shinyApp(ui = ui, server = server)

#THANKS!!




