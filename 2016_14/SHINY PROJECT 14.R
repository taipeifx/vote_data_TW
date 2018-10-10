cat('\014') #clears console
rm(list = ls()) #removes global environment
library(dplyr)
library(readr) 

#Start with new templates in mysql workbench

######################### LOAD elbase for english translations #######################
a = read_csv("AName14.csv",col_names = T)
#elbase_14 = elbase_14[order(elbase_14$X1, decreasing = F),]
#elbase_14 = elbase_14[order(elbase_14$X4, decreasing = F),]
#elbase_14 = elbase_14[order(elbase_14$X5, decreasing = F),]

a = elbase_14[elbase_14$V5 == "0000",]
View(a)

#rownames(elbase_14) = NULL
#elbase_14 = elbase_14[order(elbase_14$V4, decreasing = F),]
write_csv(elbase_14,"elbase_14.csv")

### write csv file with english translations, save as AName14E.txt for mysql use 
# remember Fangliao Township
write_csv(c,"ANameE1.csv")
#b = read_table("AName14E.txt", col_names = F)
b = read_csv("AName14.csv")
c = data.frame(a,b)

#translate, load with mysql

##load candidate names in R
elcand_14 = read_csv("elcand.csv",col_names = F)

elcand_14["X7"]

#copy, and translate back in mysql
#continue in mysql, then go to data cleaning 14 in mysql



######################### LOAD 10 ##############################################
# after creating the tks_cand_xx file in mysql...

tks_cand_14 <- read_csv("tks_cand_14.csv")
View(tks_cand_14)

"tidyr spread() on tks_cand_9: CanNames + PParty to VotesGot (Candidates x) with VotesGot values"
library(tidyverse)

tks_cand_14u = unite(data = tks_cand_14,col = CanNames.PParty, c(8:9), sep = ": ", remove = T) #unite CanNames.PParty

tks_cand_14us = spread(data = tks_cand_14u, key = CanNames.PParty, value = VotesGot) #spread CanNames.PParty and VotesGot

View(tks_cand_14us)

### write_csv and grab to mysql uploads for use, also grab new column names
write_csv(x = tks_cand_14us, path = "tks_cand_14us.csv",col_names = T) 
colnames(tks_cand_14us)


## should have final_14 by now:
final_14 = read_csv("final_14.csv")
View(final_14)

#let's reorder it
#final_14 = final_14[order(final_14$TotalVote, decreasing = T),]
#write_csv(x = final_14, "final_14.csv") #resave it

#sum(final_14[1,c(9:10)]) #check if sum of votes = ValidBallot

##check if total votes match up:
final_14$TotalVote[1] #[1] 12448302
sum(final_14$TotalVote[c(2:10, 12:16,18,23, 29,33,54,106, 123,564)]) #12448302


################## The following areas make up the entire taiwan vote
#[1] "新北市" "高雄市" "臺北市" "臺中市" "桃園縣" "臺南市" "彰化縣" "屏東縣" "雲林縣" "苗栗縣" "嘉義縣"
#[12] "南投縣" "新竹縣" "宜蘭縣" "新竹市" "基隆市" "花蓮縣" "嘉義市" "臺東縣" "澎湖縣" "金門縣" "連江縣"
final_14$AName[c(2:10, 12:16,18,23, 29,33,54,106, 123,564)]

final_14[final_14$AName == "連江縣",]
