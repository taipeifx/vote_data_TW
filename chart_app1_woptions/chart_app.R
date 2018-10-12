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
partylines = read_csv('partylines1.txt')

Category = c('Party')

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
                                choices = Category,
                                selected = 'Party'
                    ),
                    selectInput("year",
                                h4('By Year:'),
                                choices = unique(partylines$Year),
                                selected = '2006'
                    )
             ),
             column(9, htmlOutput('charta'))
           ))
)



# Define server logic for histogram
server <- function(input, output) {

  v_chart = reactive({ #v_chart returns tt
    tt = filter(partylines, Year == input$year & ANameE %in% input$city) %>% #based on selection Year, ANameE, Party + Votes
    select(ANameE, Party, Votes)
    ttname= names(tt)   #ttname returns column headers
    tt= tt %>% dcast(as.formula(paste(ttname[1:2], collapse ='~')), value.var = ttname[3]  ) # 1 row with each party as a column header
    return(tt) 
  })
  
  output$charta = renderGvis({
    print (names(v_chart())[-1]) #debug purposes
    g1 = gvisBarChart(v_chart(), "ANameE", names(v_chart())[-1], #bar chart (data, ANameE, party names)
                      options = list(colors= "['#00FF00','#0000EE', '#FFFF00', '#ffa500', '#EE3B3B']",
                                     legend="right",
                                     bar="{groupWidth:'90%'}",gvis.editor="Make a change?",
                                     width=700,height=400))
    g1
  })
}
# Run the application 
shinyApp(ui = ui, server = server)

#THANKS!!

#change colors
#if select year, show total votes? candidates input$year = 2006 etc 

