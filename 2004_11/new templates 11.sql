use vote_data;

#elctks has 43862 obs which should be correct
#elctks20160523 has 43863 obs. why?



# ENGLISH TEMPLATES############# ONE ###############
CREATE TABLE `vote_data`.`elbase_11` (
  `V1` INT(3) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` INT(4) NULL,
  `AName` CHAR(30) NULL
  )
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/11/elbase.csv' #change
INTO TABLE elbase_11 #change
FIELDS TERMINATED BY ',';
#IGNORE 1 lines;
SELECT DISTINCT * FROM elbase_11;

SELECT DISTINCT * FROM elbase_9a WHERE V5 = 0;

##check to see difference between elbase9&10.

SELECT DISTINCT *  #interesting. maybe the second elections they improved the voting process and added more districts?
FROM elbase_9a
LEFT OUTER JOIN elbase_10
ON elbase_9a.V1 = elbase_10.V1 AND elbase_9a.V2 = elbase_10.V2 AND elbase_9a.V3 = elbase_10.V3 AND elbase_9a.V4 = elbase_10.V4 AND elbase_9a.V5 = elbase_10.V5
WHERE elbase_9a.V5 = 0; #-1 alishan township in 2010

SELECT * FROM prof_tks_cand_9;



CREATE TABLE `vote_data`.`elbase_11E` (
  `ANameE` CHAR(30) NULL
  );

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/11/AName11E.txt' #change
INTO TABLE elbase_11E #change
FIELDS TERMINATED BY ',';
#IGNORE 1 lines;
SELECT * FROM elbase_11E;

# to add english translations of ANameE column to elbase_9
# 1. add null column to ellbase_9att which is a table of english translations
# 2. create new table with information from both _9 and _9att, using pseudo row values
# #. new table is LEFT OUTER JOINED to original table on AName = AName

ALTER TABLE elbase_11E  #add a NULL column
ADD COLUMN V4 CHAR(30) AFTER ANameE; #to sort 

CREATE TABLE elbase_11E2 AS #create new table from pseudo tables
SELECT T1.AName, T2.ANameE from
(select *, row_number() over (order by V5) as rn from elbase_11) T1  #pseudo value row num, V5 to match up
,
(select *, row_number() over (order by V4) as rn from elbase_11E) T2 #pseudo value row num
WHERE T1.rn = T2.rn; #row numbers = each other

SELECT * FROM elbase_11E2;
#merge above elbase_10E2 with below elbase_10

CREATE TABLE elbase_11A 
SELECT DISTINCT elbase_11.V1, elbase_11.V2, elbase_11.V3, elbase_11.V4, elbase_11.V5, elbase_11.AName, elbase_11E2.ANameE 
FROM elbase_11 
LEFT OUTER JOIN elbase_11E2
ON elbase_11.AName = elbase_11E2.AName;

#################### TWO ################################### 
CREATE TABLE `vote_data`.`elcand_11` (
  `V1` INT(2) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` INT(4) NULL,
  `CanNum` INT(3) NULL,
  `CanName` VARCHAR(80) NULL,
  `PPN` INT(3) NULL,
  `Sex` INT(1) NULL,
  `Bday` INT(7) NULL,
  `Age` INT(3) NULL,
  `BPlace` VARCHAR(10) NULL,
  `Edu` VARCHAR(10) NULL,
  `CurInc` VARCHAR(1) NULL,
  `Win` VARCHAR(2) NULL,
  `RMate` VARCHAR(2) NULL)
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/11/elcand.csv' #change
INTO TABLE elcand_11 #change
FIELDS TERMINATED BY ',';

#"陳水扁" "呂秀蓮" "連戰"   "宋楚瑜"

##update candidate names
UPDATE elcand_11
SET CanName = '陳水扁 Chen Shui-bian'
WHERE CanName = '陳水扁';

UPDATE elcand_11
SET CanName = '呂秀蓮 Annette Lu'
WHERE CanName = '呂秀蓮';

UPDATE elcand_11
SET CanName = '連戰 Lien Chan'
WHERE CanName = '連戰';

UPDATE elcand_11
SET CanName = '宋楚瑜 James Soong'
WHERE CanName = '宋楚瑜';


SELECT * FROM elcand_11;
#################### THREE ################################### elpaty_10 is the same
#CREATE TABLE `vote_data`.`elpaty_9` (
#  `PPN` INT(3) NULL,
#  `PParty` VARCHAR(40) NULL)
#DEFAULT CHARACTER SET = utf8;

#LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/9/elpaty.csv' #change
#INTO TABLE elpaty_9 #change
#FIELDS TERMINATED BY ',';

### update a single row's column
UPDATE elpaty_9
SET PParty = 'Kuo.Min.Tang'
WHERE PPN = 1;

UPDATE elpaty_9
SET PParty = 'Dem.Prog.Party'
WHERE PPN = 2;

UPDATE elpaty_9
SET PParty = 'New.Party'
WHERE PPN = 3;

UPDATE elpaty_9
SET PParty = 'Independent'
WHERE PPN = 98;

UPDATE elpaty_9
SET PParty = 'Independents'
WHERE PPN = 99;

SELECT * FROM elpaty_9; #save as elpaty_10?
#################### FOUR ################################### 
CREATE TABLE `vote_data`.`elprof_11` (
  `V1` INT(2) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` INT(4) NULL,
  `PollN` INT(4) NULL,
  `ValidBallot` INT(8) NULL,
  `InvalBallot` INT(8) NULL, 	
  `TotalVote` INT(8) NULL, 	
  `EligVoter` INT(8) NULL, 	
  `TotalPop` INT(8) NULL, 	
  `CandAmount` INT(4) NULL, 	
  `ElecAmount` INT(4) NULL, 	
  `CandMale` INT(4) NULL, 
  `CandFemale` INT(4) NULL, 	
  `ElecMale`	INT(4) NULL, 	
  `ElecFemale`	INT(4) NULL, 	
  `PerEligVoter` DECIMAL(7,2) NULL, 	
  `PerActVote` DECIMAL(7,2) NULL, 	
  `PerElected` DECIMAL(7,2) NULL)
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/11/elprof.csv' #change
INTO TABLE elprof_11 #change
FIELDS TERMINATED BY ',';

SELECT * FROM elprof_11;

#################### FIVE ################################### 
CREATE TABLE `vote_data`.`elctks_11` (
  `V1` INT(2) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` INT(4) NULL,
  `PollN` INT(4) NULL,
  `CanNum` INT(4) NULL,
  `VotesGot` INT(8) NULL,
  `PerVotes` DECIMAL(7,2) NULL,
  `Win` VARCHAR(2) NULL);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/11/elctks.csv' #change
INTO TABLE elctks_11 #change
FIELDS TERMINATED BY ',';

#elctks has 43862 obs which should be correct
#elctks20160523 has 43863 obs. why? 11xx
#compare: elctks_11 with elctks_11xx
# manual search in R resulted in an extra row #15393 , V4 0178

#################### tks_cand_9us ################################### 
#3 "tidyr spread() on elctks: CanNum to VotesGot (CanNum1 , 2, 3, 4 with VotesGot values"
#"tidyr spread() on elctks: CanNames + PParty to VotesGot (Candidates x 4 with VotesGot values"
#done in R, grab tks_cand_9us
CREATE TABLE `vote_data`.`tks_cand_9us` (
  `V1` INT(2) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` INT(4) NULL,
  `PollN` INT(4) NULL,
  `李登輝 Lee Teng-hui,連戰 Lien Chan: Kuo.Min.Tang` INT(8) NULL,
  `林洋港 Lin Yang-kang,郝柏村 Hau Pei-tsun: New.Party` INT(8) NULL,
  `陳履安 Chen Li-an,王清峰 Wang Ching-feng: Independent` INT(8) NULL,
  `彭明敏 Peng Ming-min,謝長廷 Frank Hsieh: Dem.Prog.Party` INT(8) NULL)
DEFAULT CHARACTER SET = utf8;