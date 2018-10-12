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

# Define UI for histogram
ui <-  navbarPage(
  title = 'Taiwan Votes',
  id = 'nav',
  theme = shinytheme('flatly'),
  
  tabPanel('Charts',
           fluidRow(
             column(3,
                    h3('Interactive Chart'),
                    br(),
                    br(),
                    br(),
                    selectizeInput("year",
                                   h4("Select Year(s)"),
                                   choices = unique(partylines$Year), 
                                   selected = c('1996'),
                                   multiple = TRUE
                    ),
                    br(),
                    selectInput("category",
                                h4("By Category"),
                                choices = c('Vote Count', '% of Votes (%)', 'Total Pop', 
                                            'Total Voters', 'Invalid Ballots (%)', "Eligible Voters that Voted (%)"),
                                selected = 'Vote Count'
                    ),
                    selectInput("city",
                                h4('By Area:'),
                                choices = unique(partylines$ANameE),
                                selected = 'Taipei City' #,'Taichung City','Tainan City'),
                    )
             ),
             column(9, htmlOutput('charta'))
           ))
)



# Define server logic for histogram
server <- function(input, output) {

# SELECTION #('Vote Count', '% of Votes (%)', 'Total Pop', 'Total Voters', 'Invalid Ballots (%)', "Eligible Voters that Voted (%)")
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
  
#charts based on SELECTION #
  
  v_chart = reactive({ #v_chart returns tt, input from VP
    tt = filter(partylines, ANameE == input$city & Year %in% input$year) %>% #based on selection ANameE, Year, Party + Votes
      select("Year", "Party", sprintf("%s", VP())) #input for votes or percentage? VP = Votes or Perc
    ttname= names(tt)   #ttname returns column headers
    tt= tt %>% dcast(as.formula(paste(ttname[1:2], collapse ='~')), value.var = ttname[3]  ) # 1 row with year, each party as a column header
    return(tt) 
  })
  
  v_chart2 = reactive({ #v_chart returns zz, input from VP2
    zz = filter(partylines, ANameE == input$city & Year %in% input$year) %>% #based on selection ANameE, Year, Party + Votes
      select("Year", sprintf("%s", VP2())) #input for TotalPop, TotalVote, PercIB, PercAV
    zz = unique(zz)  #ttname returns column headers
    zz$Year = as.factor(zz$Year)
    return(zz) 
  })
  
  output$charta = renderGvis({
    #print (names(v_chart())[-1]) #debug purposes
    
    if (input$category == 'Vote Count' | input$category == '% of Votes (%)'){
    g1 = gvisColumnChart(v_chart(), "Year", names(v_chart())[-1], #column chart (data, ANameE, party names), these are names of columns in the data file
                         options = list(colors= "['#00FF00','#0000EE', '#FFFF00', '#ffa500', '#EE3B3B', '#FF00FF']",
                                        legend="right",
                                        bar="{groupWidth:'90%'}",gvis.editor="Make a change?",
                                        width=700,height=400))} else{

    if (input$category == 'Total Pop' | input$category == 'Total Voters' |
    input$category == 'Invalid Ballots (%)' | input$category == 'Eligible Voters that Voted (%)'){
    g1 = gvisColumnChart(v_chart2(), #column chart (data, ANameE, party names), these are names of columns in the data file
                           options = list(colors= "['#00FF00','#0000EE', '#FFFF00', '#ffa500', '#EE3B3B', '#FF00FF']",
                                          legend="right",
                                          bar="{groupWidth:'90%'}",gvis.editor="Make a change?",
                                          width=700,height=400))}
    }
                                            
    g1
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