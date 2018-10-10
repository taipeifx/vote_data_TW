cat('\014') #clears console
rm(list = ls()) #removes global environment
library(dplyr)

tpe = read.csv('taipei_report.csv', stringsAsFactors=FALSE)   
taipei = select(tpe, 編號, 資料名稱, 更新頻率, 資料集描述, 資料量, 資料集類型, 最後更新時間)
taipei = select(tpe, 編號, 資料名稱, 資料集描述)
#summary(taipei)

taipei = filter(taipei, taipei["資料集類型"] == "原始資料")
taipei = filter(taipei, taipei["資料量"] > 0) %>% arrange(desc(資料量))
taipei = filter(taipei, grepl('2018', 最後更新時間)) #contains 2018
taipei = filter(taipei, taipei["更新頻率"] == "每天") #taipei[4][3,])


unique(taipei["資料來源"])
unique(taipei["計費方式"])
#taipei1 = filter(taipei, taipei["計費方式"] == "免費")


################=========================###################
#Oct 5: how to use the vote data? http://data.cec.gov.tw/選舉資料庫/votedata.zip
#https://github.com/MISNUK/CECDataSet/blob/master/RawData_Format.md

#lee teng hui, 9, 1996-2000
#chen shui-bian, 10-11, 2000-2008
#ma ying-jeou, 12-13, 2008-2016
#tsai ing-wen, 14, 2016-
bnames = read.table('yob2014.txt', header = F, sep = ",", stringsAsFactors = F)
data <-read.csv("mydata.csv", encoding="UTF-8", stringsAsFactors=FALSE)

######################### LOAD 9 ##############################################
elbase_9 = na.omit(read.csv("elbase_9.csv", encoding="UTF-8", header = F, stringsAsFactors = F, quote = "")) ##THIS WORKS with excel file exported from 
#mysql with Line Separator = LF, Englose Strings in ", Field Separator = "," 
rownames(elbase_9) <- NULL #renumber the rows

elcand_9 = na.omit(read.csv("elcand_9.csv", encoding="UTF-8", header = T, stringsAsFactors = F, quote = ""))  
rownames(elcand_9) <- NULL #renumber the rows

elctks_9 = na.omit(read.csv("elctks_9.csv", encoding="UTF-8", header = T, stringsAsFactors = F, quote = ""))
rownames(elctks_9) = NULL

elpaty_9 = read.csv("elpaty_9.csv", encoding="UTF-8", header = T, stringsAsFactors = F, quote = "")
#manually edited csv

elprof_9 = read.csv("elprof_9.csv", encoding="UTF-8", header = T, stringsAsFactors = F, quote = "")
#wow perfect

View(elbase_9)

######################### LOAD 10 ##############################################








"So I found a database that I think I'd like to work with, Taiwan election results (1996 - 2016): http://data.cec.gov.tw/選舉資料庫/votedata.zip . 
It comes with 5 files in each separate folder (elbase, elcand, elctks, elpaty, elprof). And for the longest time I couldn't open these in RStudio without issue.
Plus I wasn't able to decipher these files until I found this :  https://github.com/MISNUK/CECDataSet/blob/master/RawData_Format.md .
It looks like it provides schema for creating a table in MySQL. However, I don't think we went through the LOAD DATA LOCAL INFILE methods in class.

I think that I would like to create a MySQL database and load the different election result files as tables. My question"
#create templates
#upload 1 folder csv
#export csv
#open with R
#translate...

#MySQL code for elbase template:
CREATE TABLE `vote_data`.`elbase_9` (
  `省市別` INT(2) NULL,
  `縣市別` INT(3) NULL,
  `選別` INT(2) NULL,
  `鄉鎮市區` INT(3) NULL,
  `村里別` INT(4) NULL,
  `名稱` CHAR(30) NULL)
DEFAULT CHARACTER SET = utf8;

CREATE TABLE elbase_ten AS SELECT * FROM elbase_nine;

#MySQL code for elcand_template:
CREATE TABLE `vote_data`.`elcand_9` (
  `省市別` INT(2) NULL,
  `縣市別` INT(3) NULL,
  `選區別` INT(2) NULL,
  `鄉鎮市區` INT(3) NULL,
  `村里別` INT(4) NULL,
  `號次` INT(3) NULL,
  `名字` VARCHAR(80) NULL,
  `政黨代號` INT(3) NULL,
  `性別` INT(1) NULL,
  `出生日期` INT(7) NULL,
  `年齡` INT(3) NULL,
  `出生地` VARCHAR(10) NULL,
  `學歷` VARCHAR(10) NULL,
  `現任` VARCHAR(1) NULL,
  `當選註記` VARCHAR(2) NULL,
  `副手` VARCHAR(2) NULL)
DEFAULT CHARACTER SET = utf8;

#MySQL code for elpaty template:
CREATE TABLE `vote_data`.`elpaty_9` (
  `政黨代號` INT(3) NULL,
  `政黨名稱` VARCHAR(40) NULL)
DEFAULT CHARACTER SET = utf8;

#MySQL code for elprof_template:
CREATE TABLE `vote_data`.`elprof_9` (
  `省市別` INT(2) NULL,
  `縣市別` INT(3) NULL,
  `選區別` INT(2) NULL,
  `鄉鎮市區` INT(3) NULL,
  `村里別` INT(4) NULL,
  `投開票所` 	INT(4) NULL,
  `有效票` 	INT(8) NULL,
  `無效票` 	INT(8) NULL, 	
  `投票數` 	INT(8) NULL, 	
  `選舉人數` 	INT(8) NULL, 	
  `人口數` 	INT(8) NULL, 	
  `候選人數合計` 	INT(4) NULL, 	
  `當選人數合計` 	INT(4) NULL, 	
  `候選人數-男` 	INT(4) NULL, 	
  `候選人數-女` 	INT(4) NULL, 	
  `當選人數-男` 	INT(4) NULL, 	
  `當選人數-女` 	INT(4) NULL, 	
  `選舉人數對人口數` 	DECIMAL(7,2)NULL, 	 #a percentage, DOUBLE(7,4)
  `投票數對選舉人數` 	DECIMAL(7,2) NULL, 	
  `當選人數對候選人數` 	DECIMAL(7,2) NULL)
DEFAULT CHARACTER SET = utf8;
#USE INT INSTEAD OF DOUBLE IF NO DECIMALS

write.csv(elbase_nine, file = "elbase_nine2.csv", row.names=T)

#MySQL code for elctks_template:
CREATE TABLE `vote_data`.`elctks_9` (
  `省市別` INT(2) NULL,
  `縣市別` INT(3) NULL,
  `選區別` INT(2) NULL,
  `鄉鎮市區` INT(3) NULL,
  `村里別` INT(4) NULL,
  `投開票所` INT(4) NULL,
  `候選人號次` INT(4) NULL,
  `得票數` INT(8) NULL,
  `得票率` DECIMAL(7,2) NULL,
  `當選註記` VARCHAR(2) NULL);  

## THIS WORKS
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/elprof2.csv' 
INTO TABLE elprof_9
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY ' '
IGNORE 1 lines;

SHOW VARIABLES LIKE "secure_file_priv";
SELECT @@global.secure_file_priv;

########### 5 files #######################
"elbase.csv : 行政區基本資料, Administrative Regions  (region key, 5 variables, V1:V5)"
`省市別` : City number V1
`縣市別` : County V2
`選別`    : voting district V3 (all 0) 
`鄉鎮市區` : Township V4
`村里別` : Village V5
`名稱` : Area Name

"elcand.csv : 候選人基本資料, Candidates" "(5 region variables, V1:V5)" "political party"
號次: Number on Ballot / Candidate Number
名字: 	 	Name of Candidate
政黨代號: Number denoting Political Party	
性別: 	Gender, 1 Male 2 Female
出生日期: Birthday (in Taiwan calendar years)
年齡: 	Age
出生地: 	Birthplace 	
學歷 :	Education	
現任 :	Y/N current incumbent
當選註記 : 	* denotes elected 
副手 : Y denotes Running Mate 

"elpaty.csv : 政黨基本資料, Political Party / affiliation (polical party key)"
政黨代號: Num Denoting Political Party	
政黨名稱:	Political Party

"elprof.csv : 選舉概況檔, Election Demographics / stats / turnout rates" "(5 region variables, V1:V5)" 
投開票所: polling place number
有效票: Valid Ballots , Votes
無效票: Invalid Ballots	
投票數: Total Number of Votes
選舉人數: Number of Registered Voters, Eligible Voters
人口數  :	Total Population
候選人數合計: Number of Candidates 	
當選人數合計: Number of Elected
候選人數-男 :	Number of Male Candidates
候選人數-女 :	Number of Female Candidates
當選人數-男 :	Number of Elected Males	
當選人數-女 :	Number of Elected Females
選舉人數對人口數:	Registered Voters / Population
投票數對選舉人數: Number of Votes / Registered Voters
當選人數對候選人數:	Num of Elected / Num of Candidates


"elctks.csv: 候選人得票檔, Election Results" "(5 region variables, V1:V5)" 
投開票所: polling place number
候選人號次: Candidate Number
得票數: Number of Votes Received  	
得票率: Percentage of votes  	
當選註記: * denotes elected


"elpaty.csv : 政黨基本資料, Political Party / affiliation (polical party key)"
#2 Var:
colnames(elpaty_9)= c("PPN", "PParty") #update column names

"elbase.csv : 行政區基本資料, Administrative Regions  (region key, 5 variables, V1:V5)"
#6 Var:
colnames(elbase_9)= c("V1", "V2", "V3", "V4", "V5", "AName") 

"elcand.csv : 候選人基本資料, Candidates" "(5 region variables, V1:V5)" "political party"
#16 Var:
colnames(elcand_9)= c("V1", "V2", "V3", "V4", "V5", "CanNum", "CanName", "PPN", "Sex", "Bday", "Age", "BPlace", "Edu", "CurInc", "Win", "RMate") 

"elprof.csv : 選舉概況檔, Election Demographics / stats / turnout rates" "(5 region variables, V1:V5)" 
#20 Var:  
colnames(elprof_9)= c("V1", "V2", "V3", "V4", "V5", "PollN", "ValidBallot", "InvalBallot", "TotalVote", "EligVoter", "TotalPop", "CandAmount", "ElecAmount", "CandMale", "CandFemale", "ElecMale", "ElecFemale", "PerEligVoter", "PerActVote", "PerElected") 

"elctks.csv: 候選人得票檔, Election Results" "(5 region variables, V1:V5)" 
#10 Var: 
colnames(elctks_9)= c("V1", "V2", "V3", "V4", "V5", "PollN", "CanNum", "VotesGot", "PerVotes", "Win") 

##################### EDITS ###########################
# elpaty_9 edits #
elpaty_9[1,][2] = "Kuo.Min.Tang"
elpaty_9[2,][2] = "Dem.Pro.Party"
elpaty_9[3,][2] = "New.Party"
elpaty_9[4,][2] = "Independent"
elpaty_9[5,][2] = "Independents"

# elcand_9 edits #
elcand_9[7,][8] = 3
elcand_9[8,][8] = 3

# elctks_9 edits#
elctks_9 #remove " from "* in win column

# elprof_9 edits #

#elbase_9 edits#
 # translate all the ANames , all V5 = 0?
a = elbase_9[elbase_9$V5 == 0,]
View(a)

write.csv(a[6],file = "AName.csv", row.names = F)
b = read.csv("AName.csv", encoding="UTF-8", header = F, stringsAsFactors = F, sep= ",")

elbase_9$ANameE = elbase_9$AName
elbase_9$ANameE[1:396] = as.character(b[2][1:396,])
elbase = as.data.frame(elbase_9)
write.csv(elbase_9, file = "elbaseE.csv", row.names = F)

elcand_9$CanName
################################################


################### DATA CLEANING #############################
"attach elpaty to elcand" # as candidates_9 
CREATE TABLE candidates_9 AS 
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
View(Cand_9att)

"attach this to elctks before cleaning"
tks_cand_9 <- read_csv("tks_cand_9.csv")
View(tks_cand_9)

"tidyr spread() on tks_cand_9: CanNames + PParty to VotesGot (Candidates x 4 with VotesGot values"
library(tidyverse)
#flights3 = unite(flights2, date, c(1:3), sep = "-", remove = FALSE)
tks_cand_9u = unite(data = tks_cand_9,col = CanNames.PParty, c(8:9), sep = ": ", remove = T) #unite CanNames.PParty

#weather3 <- weather2 %>% spread(element, value) #NEEDS POLLN
tks_cand_9us = spread(data = tks_cand_9u, key = CanNames.PParty, value = VotesGot)#spread CanNames.PParty and VotesGot
#write_csv(x = tks_cand_9us, path = "tks_cand_9us.csv",col_names = T)
tks_cand_9us = read_csv("tks_cand_9us.csv")

"clean up elprof as elprof_9c and attach tks_cand_9us to it"
"this should be done in mysql: load tks_cand_9us into mysql"
elprof_9c = read_csv("elprof_9c.csv")
colnames(tks_cand_9us)

sum(tks_cand_9us[1,c(7:10)]) #sum of votes from tks_cand_9us matches elprof_9c ValidBallot

#grab prof_tks_cand_9.csv
prof_tks_cand_9 = read_csv("prof_tks_cand_9.csv")


"attach elbase last?"
#attach elbase_9a to prof_tks_cand_9 in mysql as final_9
final_9 = read_csv("final_9.csv")
























