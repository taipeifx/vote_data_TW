cat('\014') #clears console
rm(list = ls()) #removes global environment
library(dplyr)

tpe = read.csv('taipei_report.csv', stringsAsFactors=FALSE)   
taipei = select(tpe, �s��, ��ƦW��, ��s�W�v, ��ƶ��y�z, ��ƶq, ��ƶ�����, �̫��s�ɶ�)
taipei = select(tpe, �s��, ��ƦW��, ��ƶ��y�z)
#summary(taipei)

taipei = filter(taipei, taipei["��ƶ�����"] == "��l���")
taipei = filter(taipei, taipei["��ƶq"] > 0) %>% arrange(desc(��ƶq))
taipei = filter(taipei, grepl('2018', �̫��s�ɶ�)) #contains 2018
taipei = filter(taipei, taipei["��s�W�v"] == "�C��") #taipei[4][3,])


unique(taipei["��ƨӷ�"])
unique(taipei["�p�O�覡"])
#taipei1 = filter(taipei, taipei["�p�O�覡"] == "�K�O")


################=========================###################
#Oct 5: how to use the vote data? http://data.cec.gov.tw/���|��Ʈw/votedata.zip
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








"So I found a database that I think I'd like to work with, Taiwan election results (1996 - 2016): http://data.cec.gov.tw/���|��Ʈw/votedata.zip . 
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
  `�٥��O` INT(2) NULL,
  `�����O` INT(3) NULL,
  `��O` INT(2) NULL,
  `�m������` INT(3) NULL,
  `�����O` INT(4) NULL,
  `�W��` CHAR(30) NULL)
DEFAULT CHARACTER SET = utf8;

CREATE TABLE elbase_ten AS SELECT * FROM elbase_nine;

#MySQL code for elcand_template:
CREATE TABLE `vote_data`.`elcand_9` (
  `�٥��O` INT(2) NULL,
  `�����O` INT(3) NULL,
  `��ϧO` INT(2) NULL,
  `�m������` INT(3) NULL,
  `�����O` INT(4) NULL,
  `����` INT(3) NULL,
  `�W�r` VARCHAR(80) NULL,
  `�F�ҥN��` INT(3) NULL,
  `�ʧO` INT(1) NULL,
  `�X�ͤ��` INT(7) NULL,
  `�~��` INT(3) NULL,
  `�X�ͦa` VARCHAR(10) NULL,
  `�Ǿ�` VARCHAR(10) NULL,
  `�{��` VARCHAR(1) NULL,
  `������O` VARCHAR(2) NULL,
  `�Ƥ�` VARCHAR(2) NULL)
DEFAULT CHARACTER SET = utf8;

#MySQL code for elpaty template:
CREATE TABLE `vote_data`.`elpaty_9` (
  `�F�ҥN��` INT(3) NULL,
  `�F�ҦW��` VARCHAR(40) NULL)
DEFAULT CHARACTER SET = utf8;

#MySQL code for elprof_template:
CREATE TABLE `vote_data`.`elprof_9` (
  `�٥��O` INT(2) NULL,
  `�����O` INT(3) NULL,
  `��ϧO` INT(2) NULL,
  `�m������` INT(3) NULL,
  `�����O` INT(4) NULL,
  `��}����` 	INT(4) NULL,
  `���Ĳ�` 	INT(8) NULL,
  `�L�Ĳ�` 	INT(8) NULL, 	
  `�벼��` 	INT(8) NULL, 	
  `���|�H��` 	INT(8) NULL, 	
  `�H�f��` 	INT(8) NULL, 	
  `�Կ�H�ƦX�p` 	INT(4) NULL, 	
  `����H�ƦX�p` 	INT(4) NULL, 	
  `�Կ�H��-�k` 	INT(4) NULL, 	
  `�Կ�H��-�k` 	INT(4) NULL, 	
  `����H��-�k` 	INT(4) NULL, 	
  `����H��-�k` 	INT(4) NULL, 	
  `���|�H�ƹ�H�f��` 	DECIMAL(7,2)NULL, 	 #a percentage, DOUBLE(7,4)
  `�벼�ƹ���|�H��` 	DECIMAL(7,2) NULL, 	
  `����H�ƹ�Կ�H��` 	DECIMAL(7,2) NULL)
DEFAULT CHARACTER SET = utf8;
#USE INT INSTEAD OF DOUBLE IF NO DECIMALS

write.csv(elbase_nine, file = "elbase_nine2.csv", row.names=T)

#MySQL code for elctks_template:
CREATE TABLE `vote_data`.`elctks_9` (
  `�٥��O` INT(2) NULL,
  `�����O` INT(3) NULL,
  `��ϧO` INT(2) NULL,
  `�m������` INT(3) NULL,
  `�����O` INT(4) NULL,
  `��}����` INT(4) NULL,
  `�Կ�H����` INT(4) NULL,
  `�o����` INT(8) NULL,
  `�o���v` DECIMAL(7,2) NULL,
  `������O` VARCHAR(2) NULL);  

## THIS WORKS
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/elprof2.csv' 
INTO TABLE elprof_9
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY ' '
IGNORE 1 lines;

SHOW VARIABLES LIKE "secure_file_priv";
SELECT @@global.secure_file_priv;

########### 5 files #######################
"elbase.csv : ��F�ϰ򥻸��, Administrative Regions  (region key, 5 variables, V1:V5)"
`�٥��O` : City number V1
`�����O` : County V2
`��O`    : voting district V3 (all 0) 
`�m������` : Township V4
`�����O` : Village V5
`�W��` : Area Name

"elcand.csv : �Կ�H�򥻸��, Candidates" "(5 region variables, V1:V5)" "political party"
����: Number on Ballot / Candidate Number
�W�r: 	 	Name of Candidate
�F�ҥN��: Number denoting Political Party	
�ʧO: 	Gender, 1 Male 2 Female
�X�ͤ��: Birthday (in Taiwan calendar years)
�~��: 	Age
�X�ͦa: 	Birthplace 	
�Ǿ� :	Education	
�{�� :	Y/N current incumbent
������O : 	* denotes elected 
�Ƥ� : Y denotes Running Mate 

"elpaty.csv : �F�Ұ򥻸��, Political Party / affiliation (polical party key)"
�F�ҥN��: Num Denoting Political Party	
�F�ҦW��:	Political Party

"elprof.csv : ���|���p��, Election Demographics / stats / turnout rates" "(5 region variables, V1:V5)" 
��}����: polling place number
���Ĳ�: Valid Ballots , Votes
�L�Ĳ�: Invalid Ballots	
�벼��: Total Number of Votes
���|�H��: Number of Registered Voters, Eligible Voters
�H�f��  :	Total Population
�Կ�H�ƦX�p: Number of Candidates 	
����H�ƦX�p: Number of Elected
�Կ�H��-�k :	Number of Male Candidates
�Կ�H��-�k :	Number of Female Candidates
����H��-�k :	Number of Elected Males	
����H��-�k :	Number of Elected Females
���|�H�ƹ�H�f��:	Registered Voters / Population
�벼�ƹ���|�H��: Number of Votes / Registered Voters
����H�ƹ�Կ�H��:	Num of Elected / Num of Candidates


"elctks.csv: �Կ�H�o����, Election Results" "(5 region variables, V1:V5)" 
��}����: polling place number
�Կ�H����: Candidate Number
�o����: Number of Votes Received  	
�o���v: Percentage of votes  	
������O: * denotes elected


"elpaty.csv : �F�Ұ򥻸��, Political Party / affiliation (polical party key)"
#2 Var:
colnames(elpaty_9)= c("PPN", "PParty") #update column names

"elbase.csv : ��F�ϰ򥻸��, Administrative Regions  (region key, 5 variables, V1:V5)"
#6 Var:
colnames(elbase_9)= c("V1", "V2", "V3", "V4", "V5", "AName") 

"elcand.csv : �Կ�H�򥻸��, Candidates" "(5 region variables, V1:V5)" "political party"
#16 Var:
colnames(elcand_9)= c("V1", "V2", "V3", "V4", "V5", "CanNum", "CanName", "PPN", "Sex", "Bday", "Age", "BPlace", "Edu", "CurInc", "Win", "RMate") 

"elprof.csv : ���|���p��, Election Demographics / stats / turnout rates" "(5 region variables, V1:V5)" 
#20 Var:  
colnames(elprof_9)= c("V1", "V2", "V3", "V4", "V5", "PollN", "ValidBallot", "InvalBallot", "TotalVote", "EligVoter", "TotalPop", "CandAmount", "ElecAmount", "CandMale", "CandFemale", "ElecMale", "ElecFemale", "PerEligVoter", "PerActVote", "PerElected") 

"elctks.csv: �Կ�H�o����, Election Results" "(5 region variables, V1:V5)" 
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























