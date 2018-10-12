# Chart App 1 Select Areas based on Year

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
                    br(),
                    br(),
                    br(),
                    selectizeInput("city",
                                   h4("Select Area"),
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
                    textOutput("text1"))
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
    zz$ANameE = as.factor(zz$ANameE) #?
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
  
  output$text1 <- renderText({  
    print(sprintf("%s", toppings())) # (candinfo[input$year][[1]]) #debug purposes
    #print (unique(partylines$Year))
  })
  
}
# Run the application 
shinyApp(ui = ui, server = server)

#THANKS!!

#change colors
#if select year, show total votes? candidates input$year = 2006 etc 

