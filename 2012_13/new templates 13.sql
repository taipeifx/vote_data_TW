use vote_data;



# ENGLISH TEMPLATES############# ONE elbase . create table elbase, load data ###############
CREATE TABLE `vote_data`.`elbase_13` (
  `V1` INT(3) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` INT(4) NULL,
  `AName` CHAR(30) NULL
  )
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/13/elbase.csv' #change
INTO TABLE elbase_13 #change
FIELDS TERMINATED BY ',';
#IGNORE 1 lines;

CREATE TABLE elbase_13 AS 
SELECT DISTINCT * FROM elbase_131
ORDER BY V5 ASC, V4 ASC; #reorder

SELECT * FROM elbase_13;
#DROP TABLE elbase_131;

############# ONE elbase . create elbase_13E, use R to find column to translate into english###############
CREATE TABLE `vote_data`.`elbase_13E` (
  `ANameE` CHAR(30) NULL
  );

##load file created in R 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/13/AName13E.txt' #change
INTO TABLE elbase_13E #change
FIELDS TERMINATED BY ',';

SELECT * FROM elbase_13E;

# to add english translations of ANameE column to elbase_9
# 1. add null column to ellbase_9att which is a table of english translations
# 2. create new table with information from both _9 and _9att, using pseudo row values
# #. new table is LEFT OUTER JOINED to original table on AName = AName

ALTER TABLE elbase_13E  #add a NULL column
ADD COLUMN V4 CHAR(30) AFTER ANameE; #to sort 

CREATE TABLE elbase_13E2 AS #create new table from pseudo tables
SELECT T1.AName, T2.ANameE from
(select *, row_number() over (order by V5) as rn from elbase_13) T1  #pseudo value row num, V5 to match up
,
(select *, row_number() over (order by V4) as rn from elbase_13E) T2 #pseudo value row num
WHERE T1.rn = T2.rn; #row numbers = each other

#DROP TABLE elbase_13E2;
#select *, row_number() over (order by V1) as rn from elbase_13;

SELECT * FROM elbase_13E2;
#merge above elbase_10E2 with below elbase_10

CREATE TABLE elbase_13A
SELECT DISTINCT elbase_13.V1, elbase_13.V2, elbase_13.V3, elbase_13.V4, elbase_13.V5, elbase_13.AName, elbase_13E2.ANameE 
FROM elbase_13 
LEFT OUTER JOIN elbase_13E2
ON elbase_13.AName = elbase_13E2.AName;

SELECT * FROM elbase_13A;
##continue in mysql 

#################### TWO , create elcand table with candidate names updated################################### 
CREATE TABLE `vote_data`.`elcand_13` (
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/13/elcand.csv' #change
INTO TABLE elcand_13 #change
FIELDS TERMINATED BY ',';
SELECT * FROM elcand_13;
#DROP TABLE elcand_13;
#### USE R to list candidate names ### 

1 蔡英文 Tsai Ing-wen
2 蘇嘉全 Su Jia-chyuan
3 馬英九 Ma Ying-jeou
4 吳敦義 Wu Den-yih
5 宋楚瑜 James Soong
6 林瑞雄 Lin Ruey-shiung;

##update candidate names
UPDATE elcand_13
SET CanName = '蔡英文 Tsai Ing-wen'
WHERE CanName = '蔡英文';

UPDATE elcand_13
SET CanName = '蘇嘉全 Su Jia-chyuan'
WHERE CanName = '蘇嘉全';

UPDATE elcand_13
SET CanName = '馬英九 Ma Ying-jeou'
WHERE CanName = '馬英九';

UPDATE elcand_13
SET CanName = '吳敦義 Wu Den-yih'
WHERE CanName = '吳敦義';

UPDATE elcand_13
SET CanName = '宋楚瑜 James Soong'
WHERE CanName = '宋楚瑜';

UPDATE elcand_13
SET CanName = '林瑞雄 Lin Ruey-shiung'
WHERE CanName = '林瑞雄';

UPDATE elcand_13
SET PPN = 90
WHERE PPN = 98;

SELECT * FROM elcand_13;


#################### THREE ################################### 
#elpaty_13 is different but manually changed elcand 

#continue pulling rest of data and go to data cleaning 13 
#################### FOUR ################################### 
CREATE TABLE `vote_data`.`elprof_13` (
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/13/elprof.csv' #change
INTO TABLE elprof_13 #change
FIELDS TERMINATED BY ',';

SELECT * FROM elprof_13;

#################### FIVE ################################### 
CREATE TABLE `vote_data`.`elctks_13` (
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/13/elctks.csv' #change
INTO TABLE elctks_13 #change
FIELDS TERMINATED BY ',';

#check rows are multiple : elprof_13 22593 * 2 = 45186 elctks_13
#continue to data cleaning 13 