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
             column(9, htmlOutput('charta')),
             
             
             #Candidate Info
             column(12, h3("Candidate Info"),
                       textOutput("text1"))
           ))
)



# Define server logic for histogram
server <- function(input, output) {

  v_chart = reactive({ #v_chart returns tt
    
tt = filter(partylines, Year == 2000 & ANameE %in% 'Taipei City') %>% #based on selection Year, ANameE, Party + Votes
    select(ANameE, Party, Votes)
    ttname= names(tt)   #ttname returns column headers
    tt = tt %>% dcast(as.formula(paste(ttname[1:2], collapse ='~')), value.var = ttname[3]  ) # 1 row with each party as a column header


    tt$Mean = mean(as.numeric(tt[1,][-1]))
    last = length(v_chart())-2
    print (last)
    g1 = gvisComboChart(v_chart(), "ANameE", names(v_chart())[-1], #bar chart (data, ANameE, party names)
                        options = list(seriesType = "bars",                            
                                       series=sprintf("{%s:{type:'line', 
                                       lineWidth: 10,
                                       color:'black'}}", last), #last column of tt as mean
                                       colors= "['#00e600','#0000EE', '#FFFF00', '#ffa500', '#EE3B3B']",
                                       legend="right",
                                       bar="{groupWidth:'90%'}",gvis.editor="Make a change?",
                                       width=800,height=500))}
    
    
    last = length(tt)-1
    CC <- gvisComboChart(CityPopularity, xvar = "City", yvar = c("Mean", "Popularity"), 
                         options = list(seriesType = "bars", width = 450, height = 300, title = "City Popularity", 
                                        series = "{1:{type:\"line\"}}"))
    
    
    plot(CC)    
    return(tt) 
  })
  
  output$charta = renderGvis({
    #print (names(v_chart())[-1]) #debug purposes
    g1 = gvisBarChart(v_chart(), "ANameE", names(v_chart())[-1], #bar chart (data, ANameE, party names)
                      options = list(colors= "['#00FF00','#0000EE', '#FFFF00', '#ffa500', '#EE3B3B']",
                                     legend="right",
                                     bar="{groupWidth:'90%'}",gvis.editor="Make a change?",
                                     width=700,height=400))
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

