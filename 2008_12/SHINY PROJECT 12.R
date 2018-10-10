cat('\014') #clears console
rm(list = ls()) #removes global environment
library(dplyr)
library(readr) 

#Start with new templates in mysql workbench

######################### LOAD elbase for english translations #######################
elbase_12 = read_csv("elbase.csv",col_names = F)
elbase_12 = elbase_12[order(elbase_12$X1, decreasing = F),]
elbase_12 = elbase_12[order(elbase_12$X4, decreasing = F),]
elbase_12 = elbase_12[order(elbase_12$X5, decreasing = F),]

a = elbase_12[elbase_12$X5 == "0000",]
View(a)

### write csv file with english translations, save as AName12E.txt for mysql use 
# remember Fangliao Township
write_csv(a[6],"AName12.csv")

#translate, load with mysql

##load candidate names in R
elcand_12 = read_csv("elcand.csv",col_names = F)

elcand_12["X7"]

#copy, and translate back in mysql
#continue in mysql, then go to data cleaning 12 in mysql

######################### LOAD 10 ##############################################
# after creating the tks_cand_xx file in mysql...

tks_cand_12 <- read_csv("tks_cand_12.csv")
View(tks_cand_12)

"tidyr spread() on tks_cand_9: CanNames + PParty to VotesGot (Candidates x) with VotesGot values"
library(tidyverse)

tks_cand_12u = unite(data = tks_cand_12,col = CanNames.PParty, c(8:9), sep = ": ", remove = T) #unite CanNames.PParty

tks_cand_12us = spread(data = tks_cand_12u, key = CanNames.PParty, value = VotesGot) #spread CanNames.PParty and VotesGot

View(tks_cand_12us)

### write_csv and grab to mysql uploads for use, also grab new column names
write_csv(x = tks_cand_12us, path = "tks_cand_12us.csv",col_names = T) 
colnames(tks_cand_12us)


## should have final_12 by now:
final_12 = read_csv("final_12.csv")
View(final_12)

#let's reorder it
#final_12 = final_12[order(final_12$TotalVote, decreasing = T),]
#write_csv(x = final_12, "final_12.csv") #resave it

#sum(final_12[1,c(9:10)]) #check if sum of votes = ValidBallot

##check if total votes match up:
final_12$TotalVote[1] #[1] 13221609
sum(final_12$TotalVote[c(2:13,15:18,20,22,23,31,35,50,111,132,625)]) #13221609


################## The following areas make up the entire taiwan vote
[1] "臺北市" "高雄市" "臺北縣" "宜蘭縣" "桃園縣" "新竹縣" "苗栗縣" "臺中縣" "彰化縣"
[10] "南投縣" "雲林縣" "嘉義縣" "臺南縣" "高雄縣" "屏東縣" "臺東縣" "花蓮縣" "澎湖縣"
[19] "基隆市" "新竹市" "臺中市" "嘉義市" "臺南市" "金門縣" "連江縣"

final_12[final_12$AName == "",]
