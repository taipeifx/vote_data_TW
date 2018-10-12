# Chart App 2 Select Years by Region
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
library(dplyr)
library(reshape2)#dcast
library(googleVis)

library(readr)

#data for shiny app
partylines = read_csv('partylines_updated.txt')
candinfo = read.csv('candinfo.txt',check.names=FALSE)

# Define UI for histogram
ui <-  navbarPage(
  title = 'Taiwan Votes',
  id = 'nav',
  theme = shinytheme('flatly'),
  
  tabPanel('Charts',
           fluidRow(
             column(3,
                    h3('Interactive Chart'),
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
    tt = filter(partylines, ANameE == input$city2 & Year %in% input$year2) %>% #based on selection ANameE, Year, Party + Votes
      select("Year", "Party", sprintf("%s", WP())) #input for votes or percentage? VP = Votes or Perc
    ttname= names(tt)   #ttname returns column headers
    tt= tt %>% dcast(as.formula(paste(ttname[1:2], collapse ='~')), value.var = ttname[3]  ) # 1 row with year, each party as a column header
    return(tt) 
  })
  
  w_chart2 = reactive({ #v_chart returns zz, input from VP2
    zz = filter(partylines, ANameE == input$city2 & Year %in% input$year2) %>% #based on selection ANameE, Year, Party + Votes
      select("Year", sprintf("%s", WP2())) #input for TotalPop, TotalVote, PercIB, PercAV
    zz = unique(zz)  #ttname returns column headers
    zz$Year = as.factor(zz$Year)
    return(zz) 
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
    input$category == 'Invalid Ballots (%)' | input$category2 == 'Eligible Voters that Voted (%)'){
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
  
}
# Run the application 
shinyApp(ui = ui, server = server)

#THANKS!!



#categories: 
# Party (select area, select year. shows comparison of different areas) stats of different areas across the years. show results and candidates for the parties
# ANameE        DPP    KMT   New Party    z.Independent #return tt
# Taipei City 338895 541721    346272        165541

# Year (select area, shows how an area voted each year) Stats of each area across the years 
# Year         DPP    KMT   New Party    z.Independent #return yy
# 1996       338895 541721    346272        165541

# Stats (select area, year? ) or combine this into the two categories above.

#percentages??
#population pie chart