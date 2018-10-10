cat('\014') #clears console
rm(list = ls()) #removes global environment
library(dplyr)
library(readr) 


a = elctks20160523 == X20160510elctks
b = unique(a)

unique(elctks20160523)

# 15350 - 15400
elctks20160523[15393,]
elctks[15393,]

43863/2

######################### LOAD 10 ##############################################
elbase_11 = read_csv("elbase.csv",col_names = F) 

elcand_11 = read_csv("elcand.csv",col_names = F)
                     
#elctks_9 = na.omit(read.csv("elctks_9.csv", encoding="UTF-8", header = T, stringsAsFactors = F, quote = ""))
#rownames(elctks_9) = NULL

#elpaty_9 = read.csv("elpaty_9.csv", encoding="UTF-8", header = T, stringsAsFactors = F, quote = "")
#manually edited csv

#elprof_9 = read.csv("elprof_9.csv", encoding="UTF-8", header = T, stringsAsFactors = F, quote = "")
#wow perfect

View(elbase_9)

######################### LOAD 10 ##############################################

##################### EDITS ###########################
# elpaty_9 edits #
elpaty_9[1,][2] = "Kuo.Min.Tang"
elpaty_9[2,][2] = "Dem.Pro.Party"
elpaty_9[3,][2] = "New.Party"
elpaty_9[4,][2] = "Independent"
elpaty_9[5,][2] = "Independents"

# elcand_9 edits #
elcand_10["X7"]

elcand_9[7,][8] = 3
elcand_9[8,][8] = 3

# elctks_9 edits#
elctks_9 #remove " from "* in win column
sum(elctks$X8[1:5])

#21398 elprof*5 = 106990 elctks

# elprof_9 edits #

#elbase_10 edits#
# translate all the ANames , all V5 = 0? 
# ellbase_11 row 381 they combined 2 sections from 2004 as ¤¤¦è°Ï
a = elbase_11[elbase_11$X5 == "0000",]
View(a)

write_csv(a[6],"AName111.csv")
b = read.csv("AName.csv", encoding="UTF-8", header = F, stringsAsFactors = F, sep= ",")
"
elbase_9$ANameE = elbase_9$AName
elbase_9$ANameE[1:396] = as.character(b[2][1:396,])
elbase = as.data.frame(elbase_9)
write.csv(elbase_9, file = "elbaseE.csv", row.names = F)"

elcand_11$X7
################################################



################### DATA CLEANING #############################
"attach elpaty to elcand" # as candidates_9 
"CREATE TABLE candidates_9 AS 
SELECT elcand_9.CanNum, elcand_9.CanName, elcand_9.Sex, elcand_9.Age, elcand_9.CurInc, elpaty_9.PParty, elcand_9.RMate
FROM elcand_9
INNER JOIN elpaty_9
ON elcand_9.PPN = elpaty_9.PPN;

#join multiple rows into a single column (Pres, Vice Pres Cand in same row)
SELECT PPN, CanNum,
GROUP_CONCAT(CanName) AS CanNames
FROM elcand_9
GROUP BY CanNum;

cand_9 = na.omit(read.csv("cand_9.csv", encoding="UTF-8", header = T, stringsAsFactors = F, quote = ""))
colnames(cand_9)

cand_9att = read.csv("cand_9att.csv")
colnames(cand_9)

library(readr)  #!!!! UNDERSCORE
cand_9att <- read_csv("Cand_9att.csv")
View(Cand_9att)"

"attach this to elctks before cleaning"
tks_cand_11 <- read_csv("tks_cand_11.csv")
View(tks_cand_11)

"tidyr spread() on tks_cand_9: CanNames + PParty to VotesGot (Candidates x 4 with VotesGot values"
library(tidyverse)
#flights3 = unite(flights2, date, c(1:3), sep = "-", remove = FALSE)
tks_cand_11u = unite(data = tks_cand_11,col = CanNames.PParty, c(8:9), sep = ": ", remove = T) #unite CanNames.PParty

#weather3 <- weather2 %>% spread(element, value) #NEEDS POLLN
tks_cand_11us = spread(data = tks_cand_11u, key = CanNames.PParty, value = VotesGot)#spread CanNames.PParty and VotesGot
write_csv(x = tks_cand_11us, path = "tks_cand_11us.csv",col_names = T) #write to mysql uploads for use
View(tks_cand_11us)
#tks_cand_9us = read_csv("tks_cand_10us.csv")

colnames(tks_cand_9us)
"clean up elprof as elprof_9c and attach tks_cand_9us to it"
"this should be done in mysql: load tks_cand_9us into mysql"
elprof_9c = read_csv("elprof_9c.csv")


sum(tks_cand_9us[1,c(7:10)]) #sum of votes from tks_cand_9us matches elprof_9c ValidBallot

#grab prof_tks_cand_9.csv
prof_tks_cand_9 = read_csv("prof_tks_cand_9.csv")


"attach elbase last?"
#attach elbase_9a to prof_tks_cand_9 in mysql as final_9
final_10 = read_csv("final_10.csv")

final_10$TotalVote[1] #[1] 12786671
sum(final_10$TotalVote[2:26]) #[1] 12786671

################################################
