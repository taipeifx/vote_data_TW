#10/10 git hub pushed
#let's plot some graphs
library(ggplot2)
install.packages("ggThemeAssist")
library(ggThemeAssist)
#possible graphs:
  which district elected the winner the most times?
  which candidate got the most votes from a single place? the most percentage?
  area with highest voter turnout % each year?
    
#statistical analysis:
  total average vote for each political party vs each election year
  
g9plot = g9[-1,]
g = ggplot(data = g9plot, aes(x = ANameE, y = TotalVote))
g + geom_col() + theme(plot.subtitle = element_text(vjust = 1), 
    plot.caption = element_text(vjust = 1), 
    axis.text.x = element_text(vjust = 0, 
        angle = 90))
#divide each bar into party voted for
#need more bars for each year
