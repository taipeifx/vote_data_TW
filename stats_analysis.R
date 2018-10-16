library(readr)
partylines = read_csv('partylines_updated.txt')
nat = partylines[partylines$ANameE == "National",][c(-3,-5,-7,-8,-9)] 
nat = nat[(nat$Party == "DPP" | nat$Party == "KMT"),]

summary(partylines)
summary(nat)
#t-test, global anova

library('psych')

######################## NATIONAL 6 years V
describe(nat)

describe.by(nat[c(-1,-2)], nat$Party)
a$DPP$mean 
a$DPP$sd

# DPP Perc         mean, sd (for national)      41.97      11.93    
# KMT Perc         mean, sd (for national)      44.33      14.10

############################################################################ V
# Female BT vs Male BT: 
# HA: true difference in means is not equal to 0
# H0: true ratio of variances is not equal to 1
nat[nat$Party == "KMT",][4][[1]]
t.test(nat[nat$Party == "KMT",][4][[1]], nat[nat$Party == "DPP",][4][[1]]) #Welch Two Sample t-test

hist(nat$Perc, prob = T) 
lines(density(nat$Perc), col = "red")

loc = partylines[partylines$ANameE != "National",]
#loc[loc$Party == "KMT",][6][[1]]
t.test(loc[loc$Year == "1996" & loc$Party == "KMT",][6][[1]], loc[loc$Year == "1996" & loc$Party == "DPP",][6][[1]]) #Welch Two Sample t-test
#p-value < 2.2e-16

t.test(loc[loc$Year == "2000" & loc$Party == "KMT",][6][[1]], loc[loc$Year == "2000" & loc$Party == "DPP",][6][[1]])
#p-value = 6.485e-05

t.test(loc[loc$Year == "2004" & loc$Party == "KMT",][6][[1]], loc[loc$Year == "2004" & loc$Party == "DPP",][6][[1]])
#p-value = 0.07566

t.test(loc[loc$Year == "2008" & loc$Party == "KMT",][6][[1]], loc[loc$Year == "2008" & loc$Party == "DPP",][6][[1]])
#p-value = 1.322e-07

t.test(loc[loc$Year == "2012" & loc$Party == "KMT",][6][[1]], loc[loc$Year == "2012" & loc$Party == "DPP",][6][[1]])
#p-value = 0.0007392

t.test(loc[loc$Year == "2016" & loc$Party == "KMT",][6][[1]], loc[loc$Year == "2016" & loc$Party == "DPP",][6][[1]])
#p-value = 0.0002489

t.test(loc[loc$Party == "KMT",][6][[1]], loc[loc$Party == "DPP",][6][[1]])


loc2 = loc[c(-1,-2,-3,-5,-7,-8,-9)]
loc2
describe.by(loc2, loc2$Party)


#data:  loc[loc$Party == "KMT", ][6][[1]] and loc[loc$Party == "DPP", ][6][[1]]
#t = 3.3457, df = 285.16, p-value = 0.0009307
#alternative hypothesis: true difference in means is not equal to 0
#95 percent confidence interval:
#  2.833459 10.931514
#sample estimates:
#  mean of x mean of y 
#45.67188  38.78939 

hist(nat$Perc, prob = T) 
lines(density(nat$Perc), col = "red")

#############################################################################
describe.by(nat, nat$Year)
nat2 = partylines[partylines$ANameE == "National",]
loc3 = partylines[partylines$ANameE != "National",]

kmt = loc3[loc3$Party=="KMT",]
cor(x=kmt$Votes,kmt$TotalVote)
cor(x=kmt$Year,kmt$PercAV)
cor(x=kmt$Perc,kmt$PercIB) 
cor(x=kmt$Votes,kmt$TotalVote)

library(corrplot)
corrplot(cor(kmt[c(-1,-4)]), order="hclust")


dpp = loc3[loc3$Party=="DPP",]
corrplot(cor(dpp[c(-1,-4)]), order="hclust")
cor(x=dpp$Year,dpp$Perc)

#cor should be by party?
kmt = nat[nat$Party=="KMT",]
cor(x=kmt$PercAV,kmt$Perc) # 0.01809916 percent actually voted vs votes got
# -0.3627495 DPP
cor(x=kmt$PercIB,kmt$PercAV) # 0.1966199 percent inval ballots vs percent actually voted
#same 
cor(x=kmt$Perc,kmt$PercIB) # 0.05506321 percent vote gots vs percent invalid ballots
# 0.3652409 DPP

# Votes (for party), TotalVote (national), TotalPop (national)
cor(x=kmt$Votes,kmt$TotalVote) # 0.2660038 votes got vs total vote
#0.8104111 DPP
cor(x=kmt$TotalVote,kmt$TotalPop) # 0.7171051 total vote vs total pop
#same
cor(x=kmt$Votes,kmt$TotalPop) #0.1156105 votes got vs total pop
#0.9062092 DPP

#corrplot(cor(partylines), order="hclust")
######################## end NATIONAL 6 years
# describe.by(nat, nat$Party) #only national n = 6
# DPP Perc         mean, sd (for national)      41.97      11.93    
# KMT Perc         mean, sd (for national)      44.33      14.10

describe.by(locslim, locslim$Party) #only local n = 144
# DPP Perc         mean, sd (for local)      38.79     16.97    
# KMT Perc         mean, sd (for local)      45.67     17.92

loc = partylines[partylines$ANameE != "National",]
locslim = loc[c(-1,-7,-8,-9)]
describe.by(locslim, locslim$Party, locslim$Year) # 

loc96 = loc[loc$Year == "1996",]
describe.by(loc96, loc96$Party)#diff parties by year 1996

loc = partylines[partylines$ANameE != "National",]
lockmt = loc[loc$Party == "KMT",]
describe.by(lockmt, lockmt$Year) #? kmt by year
describe.by(lockmt, lockmt$Party) #?kmt over all the years 45.62 17.75
plot(density(lockmt$Perc, main = "hello"))

loc = partylines[partylines$ANameE != "National",]
locdpp = loc[loc$Party == "DPP",]
describe.by(locdpp, locdpp$Year) #? dpp by year
describe.by(locdpp, locdpp$Party) #38.79, 16.97
plot(density(locdpp$Perc))

#boxplot(kmt$Perc)


ABT = temp[1][,1] #avgbodytemp
3. You have heard that the average human body temperature is 98.6 degrees Fahrenheit. Does 
this data support this claim? (Perform a hypothesis test to determine whether the true population 
                               mean body temperature is 98.6 degrees Fahrenheit.)
+ What is a 95% confidence interval for the average human body temperature?
  + Interpret your results in context of the problem.
# We can reject the null hypothesis because the p-value is significant (p < 0.05).
# We accept the alternative hypothesis that the true mean is not equal to 98.6
# based on this data.

#95% confidence interval = 98.12200 to 98.37646

t.test(ABT, mu = 98.6, alternative = "tw") #One Sample t-test, mu indicates true value of the mean
#data:  ABT
#t = -5.4548, df = 129, p-value = 2.411e-07
#alternative hypothesis: true mean is not equal to 98.6
#95 percent confidence interval:
#  98.12200 98.37646
#sample estimates:
#  mean of x 
#98.24923 

4. Is there a significant difference in body temperature between males and females? If so, quantify this difference.
+ What is a 95% confidence interval for the average difference in human body temperature between males and females?
  + Interpret your results in context of the problem.
# Female BT vs Male BT: 
# HA: true difference in means is not equal to 0
# H0: true ratio of variances is not equal to 1
t.test(temp_us4[1][,1], temp_us4[3][,1]) #Welch Two Sample t-test

is there significant difference between kmt and dpp? or...

question: national or local, n = 6 or n = 144?

  
5. You believe the variances of male heart rate and female heart rate are different; specifically, you claim that 
females have a lower heart rate variance. Test this claim.
+ What is a 95% confidence interval for the ratio between female and male heart rate variances?
  + Interpret your results in context of the problem.
#variance is F test

FHR = temp_us4[2][,1] # female heart rate
MHR = temp_us4[4][,1] # male heart rate

var.test(FHR, MHR, alternative = "l") #F test to compare two variances
#data:  FHR and MHR
#F = 1.9032, num df = 64, denom df = 64, p-value = 0.9945
#alternative hypothesis: true ratio of variances is less than 1 
#95 percent confidence interval:
#  0.000000 2.880108
#sample estimates:
#  ratio of variances 
#1.903213 


http://www.sthda.com/english/wiki/chi-square-test-of-independence-in-r

sd(kmt$Perc) #sd of all districts throughout the 6 elections
var(kmt$Perc) #321.2547


kmtslim = kmt[c(-3,-4,-5,-7,-8,-9)] #AName, Year, Perc. group by year or district?
kmtslimdistrict = kmtslim[-2] #district first

#1 Creating side-by-side boxplots of the data.
par(mfrow=c(1,1))
ggplot(kmt, aes(x = kmt$ANameE, y = kmt$Perc)) +
  geom_boxplot() + theme(plot.subtitle = element_text(vjust = 1), 
                         plot.caption = element_text(vjust = 1), 
                         axis.line = element_line(colour = "blue4", 
                                                  linetype = "solid"), axis.ticks = element_line(colour = "gray46"), 
                         axis.title = element_text(size = 13), 
                         axis.text.x = element_text(angle = 90), 
                         plot.title = element_text(size = 15), 
                         plot.background = element_rect(fill = "aliceblue")) +labs(title = "Boxplot of Districts for 6 Elections", 
                                                                                   x = "District Name", y = "Percentage of Votes for KMT %")

#2a Calculating the standard deviations of each treatment group.
#describe.by(lockmtslimdistrict, lockmtslimdistrict$ANameE)

#Conducting the Bartlett test of homogeneity of variances.
bartlett.test(kmt$Perc~kmt$ANameE)

#Bartlett test of homogeneity of variances
#data:  lockmtslimdistrict$Perc by lockmtslimdistrict$ANameE
#Bartlett's K-squared = 19.22, df = 25, p-value = 0.7864


#3a One-Way ANOVA - access the equality of means of two or more groups?
summary(aov(kmt$Perc~kmt$ANameE)) 
# Df Sum Sq Mean Sq F value Pr(>F)
# lockmtslimdistrict$ANameE  25   1925      77   0.206      1
# Residuals                 118  44014     373    

#The p-value for this test is 1, which means we have insufficient evidence to conclude
#that the percent vote of districts differ in any significant way. 
# The Bartlett test confirmed that the variances are equal across groups. 

par(mfrow=c(2,2))
plot(aov(lockmtslimdistrict$Perc~lockmtslimdistrict$ANameE)) 

##################################### DPP
#Next I looked at side-by-side boxplots of all the election data for districts that voted for KMT. 

par(mfrow=c(1,1))
ggplot(kmt, aes(x = dpp$ANameE, y = dpp$Perc)) +
  geom_boxplot() + theme(plot.subtitle = element_text(vjust = 1), 
                         plot.caption = element_text(vjust = 1), 
                         axis.line = element_line(colour = "blue4", 
                                                  linetype = "solid"), axis.ticks = element_line(colour = "gray46"), 
                         axis.title = element_text(size = 13), 
                         axis.text.x = element_text(angle = 90), 
                         plot.title = element_text(size = 15), 
                         plot.background = element_rect(fill = "lightgreen")) +labs(title = "Boxplot of Districts for 6 Elections", 
                                                                                   x = "District Name", y = "Percentage of Votes for DPP %")


#and performed a Bartlett test of homogeneity of variances and a One-Way ANOVA test to assess the equality of means of two or more groups:
bartlett.test(dpp$Perc~dpp$ANameE) #p-value = 0.7864
summary(aov(dpp$Perc~dpp$ANameE)) 

#The p-value for the ANOVA is 1, which means we have insufficient evidence to conclude that the percent vote of districts differ in any significant way. 
# The Bartlett test confirmed that the variances are equal across groups (the districts that voted KMT). 

par(mfrow=c(2,2))
plot(aov(dpp$Perc~dpp$ANameE)) 

###########################################


#########################################################################

locchisq = lockmt[c(-3,-5,-7,-8,-9)] 
locchisq = locchisq[-3]
library(tidyr)

library(tidyverse)
asdf = spread(data = locchisq, key = Year, value = Perc) #spread CanNames.PParty and VotesGot






asdf[14,][2:5]= asdf[22,][2:5]
asdf[9,][6:7]= asdf[8,][6:7]
asdf[18,][6:7]= asdf[17,][6:7]
asdf[20,][6:7]= asdf[19,][6:7]
asdf = asdf[-22,]
adsf1 = asdf[-11,]
adsf1 = adsf1[-7,]

chisq = chisq.test(adsf1[-1])
#Pearson's Chi-squared test
#data:  asdf[-1]
#X-squared = 347.42, df = 120, p-value < 2.2e-16

# Again, the null hypothesis states that the distribution of the votes are the same for each president. 
# With a significant result, we are willing to reject this null hypothesis.
# printing the p-value
chisq$p.value

# printing the mean
chisq$estimate

# Observed counts
chisq$observed

round(chisq$expected,2)


library(corrplot)
a = corrplot(chisq$residuals, is.cor = FALSE)

contrib <- 100*chisq$residuals^2/chisq$statistic
round(contrib, 3)






#########################################################################



######################################################################### BY YEAR
sd(lockmt$Perc) #17.92358 sd of all districts throughout the 6 elections 
var(lockmt$Perc) #321.2547


lockmtslim = lockmt[c(-3,-4,-5,-7,-8,-9)] #AName, Year, Perc. group by year or district?
lockmtslimyear = lockmtslim[-1] #year
lockmtslimyear$Year = as.factor(lockmtslimyear$Year) #make as factor
#1 Creating side-by-side boxplots of the data.
par(mfrow=c(1,1))
ggplot(lockmtslimyear, aes(x = lockmtslimyear$Year, y = lockmtslimyear$Perc)) +
  geom_boxplot() + theme(plot.subtitle = element_text(vjust = 1), 
                         plot.caption = element_text(vjust = 1), 
                         axis.line = element_line(colour = "blue4", 
                                                  linetype = "solid"), axis.ticks = element_line(colour = "gray46"), 
                         axis.title = element_text(size = 13), 
                         axis.text.x = element_text(angle = 90), 
                         plot.title = element_text(size = 15), 
                         plot.background = element_rect(fill = "aliceblue")) +labs(title = "Boxplot of Districts for 6 Elections", 
                                                                                   x = "District Name", y = "Percentage of Votes for KMT %")

#2a Calculating the standard deviations of each treatment group.
describe.by(lockmtslimyear, lockmtslimyear$Year)

#Conducting the Bartlett test of homogeneity of variances.
bartlett.test(lockmtslimyear$Perc~lockmtslimyear$Year)
#Bartlett test of homogeneity of variances
#data:  lockmtslimyear$Perc by lockmtslimyear$Year
#Bartlett's K-squared = 52.127, df = 5, p-value = 5.081e-10
#variance not equal across the years



#3a One-Way ANOVA - access the equality of means of two or more groups?
summary(aov(lockmtslimyear$Perc~lockmtslimyear$Year)) 
#Df Sum Sq Mean Sq F value Pr(>F)    
#lockmtslimyear$Year   5  26885    5377   38.94 <2e-16 ***
#  Residuals           138  19054     138                   

#The p-value for this test is <2e-16, which means we have sufficient evidence to reject
# the null hypothesis that the percent vote across the years are the same. 
# The Bartlett test confirmed that the variances are not equal across groups. 

par(mfrow=c(1,4))
plot(aov(lockmtslimyear$Perc~lockmtslimyear$Year)) 

#perform by year



kmtchisqdata = kmt[c(-3,-4,-5,-7,-8,-9)] 

library(tidyr)
kmtchisqdata = spread(data = kmtchisqdata, key = ANameE, value = Perc)
#Next, because some districts were renamed in 2012, we need to fill in some missing data:
kmtchisqdata[10][5:6,]= kmtchisqdata[9][5:6,]
kmtchisqdata[15][1:4,]= kmtchisqdata[23][1:4,]
kmtchisqdata[23][5:6,]= kmtchisqdata[15][5:6,]
kmtchisqdata[19][5:6,]= kmtchisqdata[18][5:6,]
kmtchisqdata[21][5:6,]= kmtchisqdata[20][5:6,]
kmtchisqdata = kmtchisqdata[-23] #Taipei County renamed to New Taipei City


chisq = chisq.test(kmtchisqdata[-1])
chisq
#Pearson's Chi-squared test
#data:  asdf[-1]
#X-squared = 347.42, df = 120, p-value < 2.2e-16

# Again, the null hypothesis states that the distribution of the votes are the same for each president. 
# With a significant result, we are willing to reject this null hypothesis.
# printing the p-value
chisq$p.value

# printing the mean
chisq$estimate

# Observed counts
chisq$observed

round(chisq$expected,2)


library(corrplot)
a = corrplot(chisq$residuals, is.cor = FALSE)
a
contrib <- 100*chisq$residuals^2/chisq$statistic
round(contrib, 3)
contrib


############################################################################### DPP



dppchisqdata = dpp[c(-3,-4,-5,-7,-8,-9)] 

library(tidyr)
dppchisqdata = spread(data = dppchisqdata, key = ANameE, value = Perc)
#Next, because some districts were renamed in 2012, we need to fill in some missing data:
dppchisqdata[10][5:6,]= dppchisqdata[9][5:6,]
dppchisqdata[15][1:4,]= dppchisqdata[23][1:4,]
dppchisqdata[23][5:6,]= dppchisqdata[15][5:6,]
dppchisqdata[19][5:6,]= dppchisqdata[18][5:6,]
dppchisqdata[21][5:6,]= dppchisqdata[20][5:6,]
dppchisqdata = dppchisqdata[-23] #Taipei County renamed to New Taipei City


chisq2 = chisq.test(dppchisqdata[-1])
chisq2
#Pearson's Chi-squared test
#data:  asdf[-1]
#X-squared = 347.42, df = 120, p-value < 2.2e-16

# Again, the null hypothesis states that the distribution of the votes are the same for each president. 
# With a significant result, we are willing to reject this null hypothesis.
# printing the p-value
chisq$p.value

# printing the mean
chisq$estimate

# Observed counts
chisq$observed

round(chisq$expected,2)


library(corrplot)
corrplot(chisq2$residuals, is.cor = FALSE)
a
contrib <- 100*chisq$residuals^2/chisq$statistic
round(contrib, 3)
contrib

