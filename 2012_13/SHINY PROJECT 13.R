cat('\014') #clears console
rm(list = ls()) #removes global environment
library(dplyr)
library(readr) 

#Start with new templates in mysql workbench

######################### LOAD elbase for english translations #######################
elbase_13 = read_csv("elbase.csv",col_names = F)
#elbase_13 = elbase_13[order(elbase_13$X1, decreasing = F),]
#elbase_13 = elbase_13[order(elbase_13$X4, decreasing = F),]
#elbase_13 = elbase_13[order(elbase_13$X5, decreasing = F),]

a = elbase_13[elbase_13$V5 == 0,]
View(a)

### write csv file with english translations, save as AName13E.txt for mysql use 
# remember Fangliao Township
write_csv(a[6],"AName13.csv")

#translate, load with mysql

##load candidate names in R
elcand_13 = read_csv("elcand.csv",col_names = F)

elcand_13["X7"]

#copy, and translate back in mysql
#continue in mysql, then go to data cleaning 13 in mysql



######################### LOAD 10 ##############################################
# after creating the tks_cand_xx file in mysql...

tks_cand_13 <- read_csv("tks_cand_13.csv")
View(tks_cand_13)

"tidyr spread() on tks_cand_9: CanNames + PParty to VotesGot (Candidates x) with VotesGot values"
library(tidyverse)

tks_cand_13u = unite(data = tks_cand_13,col = CanNames.PParty, c(8:9), sep = ": ", remove = T) #unite CanNames.PParty

tks_cand_13us = spread(data = tks_cand_13u, key = CanNames.PParty, value = VotesGot) #spread CanNames.PParty and VotesGot

View(tks_cand_13us)

### write_csv and grab to mysql uploads for use, also grab new column names
write_csv(x = tks_cand_13us, path = "tks_cand_13us.csv",col_names = T) 
colnames(tks_cand_13us)


## should have final_13 by now:
final_13 = read_csv("final_13.csv")
View(final_13)

#let's reorder it
#final_13 = final_13[order(final_13$TotalVote, decreasing = T),]
#write_csv(x = final_13, "final_13.csv") #resave it

#sum(final_13[1,c(9:10)]) #check if sum of votes = ValidBallot

##check if total votes match up:
final_13$TotalVote[1] #[1] 13452016
sum(final_13$TotalVote[c(2:9, 10, 12:15,17,19,22, 29,33,51,106,124,478)]) #13452016


################## The following areas make up the entire taiwan vote
#[1] "新北市" "高雄市" "臺北市" "臺中市" "桃園縣" "臺南市" "彰化縣" "屏東縣" "雲林縣" "苗栗縣" "嘉義縣"
#[12] "南投縣" "新竹縣" "宜蘭縣" "新竹市" "基隆市" "花蓮縣" "嘉義市" "臺東縣" "澎湖縣" "金門縣" "連江縣"
final_13$AName[c(2:9, 10, 12:15,17,19,22, 29,33,51,106,124,478)]

final_13[final_13$AName == "臺南",]
