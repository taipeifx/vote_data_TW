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
                    selectizeInput("year",
                                   h4("Select Year(s)"),
                                   choices = unique(partylines$Year), 
                                   selected = c('1996'),
                                   multiple = TRUE
                    ),
                    br(),
                  #  selectInput("category",
                   #             h4("By Category"),
                    #            choices = Category,
                     #           selected = 'Party'
                    # ),
                    selectInput("city",
                                h4('Party By Area:'),
                                choices = unique(partylines$ANameE),
                                selected = 'Taipei City' #,'Taichung City','Tainan City'),
                    )
             ),
             column(9, htmlOutput('charta'))
           ))
)



# Define server logic for histogram
server <- function(input, output) {
#if then based on category selection? put outside of v_chart function

  v_chart = reactive({ #v_chart returns tt
    tt = filter(partylines, ANameE == input$city & Year %in% input$year) %>% #based on selection ANameE, Year, Party + Votes
    select(Year, Party, Votes) #input for votes or percentage?
    ttname= names(tt)   #ttname returns column headers
    tt= tt %>% dcast(as.formula(paste(ttname[1:2], collapse ='~')), value.var = ttname[3]  ) # 1 row with year, each party as a column header
    return(tt) 
  })
  
  output$charta = renderGvis({
    print (names(v_chart())[-1]) #debug purposes
    g1 = gvisColumnChart(v_chart(), "Year", names(v_chart())[-1], #column chart (data, ANameE, party names), these are names of columns in the data file
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