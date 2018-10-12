# Chart App 1 Select Regions based on Year &
# Chart App 2 Select Years by Region
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

#data for shiny app
partylines = read_csv('partylines_updated.txt')
candinfo = read.csv('candinfo.txt',check.names=FALSE)

# Define UI for graphs
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
                                choices = c('Vote Count', '% of Votes (%)', 'Total Pop', 
                                            'Total Voters', 'Invalid Ballots (%)', "Eligible Voters that Voted (%)"),
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
                              choices = c('Vote Count', '% of Votes (%)', 'Total Pop', 
                                          'Total Voters', 'Invalid Ballots (%)', "Eligible Voters that Voted (%)"),
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
         ))

)



# Define server logic for histogram
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
    if (input$category == 'Total Pop'){
      xx= "TotalPop"} else {
        if (input$category == 'Total Voters'){
          xx = "TotalVote"} else {
            if (input$category == 'Invalid Ballots (%)'){
              xx = "PercIB"} else {
                if (input$category == 'Eligible Voters that Voted (%)'){
                  xx = "PercAV"}
              }
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
  
  v_chart2 = reactive({ #v_chart returns tt
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
      options = list(colors= "['#00FF00','#0000EE', '#FFFF00', '#ffa500', '#EE3B3B']",
      legend="right",
      bar="{groupWidth:'90%'}",gvis.editor="Make a change?",
      width=700,height=400))} else{
                                         
      if (input$category == 'Total Pop' | input$category == 'Total Voters' |
      input$category == 'Invalid Ballots (%)' | input$category == 'Eligible Voters that Voted (%)'){
      g1 = gvisBarChart(v_chart2(),
      options = list(colors= "['#00FF00','#0000EE', '#FFFF00', '#ffa500', '#EE3B3B']",
      legend="right",
      bar="{groupWidth:'90%'}",gvis.editor="Make a change?",
      width=700,height=400))}
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
    print(sprintf("%s", toppings())) #(candinfo[input$year][[1]]) #debug purposes
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
    if (input$category2 == 'Total Pop'){
      xx= "TotalPop"} else {
        if (input$category2 == 'Total Voters'){
          xx = "TotalVote"} else {
            if (input$category2 == 'Invalid Ballots (%)'){
              xx = "PercIB"} else {
                if (input$category2 == 'Eligible Voters that Voted (%)'){
                  xx = "PercAV"}
              }
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
    zz2 = unique(zz2)  #ttname returns column headers
    zz2$Year = as.factor(zz2$Year)
    return(zz2) 
  })
  
  output$charta2 = renderGvis({
    #print (names(v_chart())[-1]) #debug purposes
    
    if (input$category2 == 'Vote Count' | input$category2 == '% of Votes (%)'){
    g2 = gvisColumnChart(w_chart(), "Year", names(w_chart())[-1], #column chart (data, ANameE, party names), these are names of columns in the data file
    options = list(colors= "['#00FF00','#0000EE', '#FFFF00', '#ffa500', '#EE3B3B', '#FF00FF']",
    legend="right",
    bar="{groupWidth:'90%'}",gvis.editor="Make a change?",
    width=700,height=400))} else{
                                          
    if (input$category2 == 'Total Pop' | input$category2 == 'Total Voters' |
    input$category2 == 'Invalid Ballots (%)' | input$category2 == 'Eligible Voters that Voted (%)'){
    g2 = gvisColumnChart(w_chart2(), 
    options = list(colors= "['#00FF00','#0000EE', '#FFFF00', '#ffa500', '#EE3B3B', '#FF00FF']",
    legend="right",
    bar="{groupWidth:'90%'}",gvis.editor="Make a change?",
    width=700,height=400))}
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
  
}

# Run the application 
shinyApp(ui = ui, server = server)

#THANKS!!
