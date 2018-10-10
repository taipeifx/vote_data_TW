use vote_data;



# ENGLISH TEMPLATES############# ONE elbase . create table elbase, load data ###############
CREATE TABLE `vote_data`.`elbase_12` (
  `V1` INT(3) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` INT(4) NULL,
  `AName` CHAR(30) NULL
  )
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/12/elbase.csv' #change
INTO TABLE elbase_12 #change
FIELDS TERMINATED BY ','
IGNORE 1 lines;

SELECT DISTINCT * FROM elbase_12E;

############# ONE elbase . create elbase_12E, use R to find column to translate into english###############
CREATE TABLE `vote_data`.`elbase_12E` (
  `ANameE` CHAR(30) NULL
  );

##load file created in R 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/12/AName12E.txt' #change
INTO TABLE elbase_12E #change
FIELDS TERMINATED BY ',';

SELECT * FROM elbase_12E2;

# to add english translations of ANameE column to elbase_9
# 1. add null column to ellbase_9att which is a table of english translations
# 2. create new table with information from both _9 and _9att, using pseudo row values
# #. new table is LEFT OUTER JOINED to original table on AName = AName

ALTER TABLE elbase_12E  #add a NULL column
ADD COLUMN V4 CHAR(30) AFTER ANameE; #to sort 

CREATE TABLE elbase_12E2 AS #create new table from pseudo tables
SELECT T1.AName, T2.ANameE from
(select *, row_number() over (order by V5) as rn from elbase_12) T1  #pseudo value row num, V5 to match up
,
(select *, row_number() over (order by V4) as rn from elbase_12E) T2 #pseudo value row num
WHERE T1.rn = T2.rn; #row numbers = each other

#DROP TABLE elbase_12E2;
#select *, row_number() over (order by V1) as rn from elbase_12;



SELECT * FROM elbase_12E2;
#merge above elbase_10E2 with below elbase_10

CREATE TABLE elbase_12A 
SELECT DISTINCT elbase_12.V1, elbase_12.V2, elbase_12.V3, elbase_12.V4, elbase_12.V5, elbase_12.AName, elbase_12E2.ANameE 
FROM elbase_12 
LEFT OUTER JOIN elbase_12E2
ON elbase_12.AName = elbase_12E2.AName;

SELECT * FROM elbase_12A;
##continue in mysql 

#################### TWO , create elcand table with candidate names updated################################### 
CREATE TABLE `vote_data`.`elcand_12` (
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/12/elcand.csv' #change
INTO TABLE elcand_12 #change
FIELDS TERMINATED BY ',';
SELECT * FROM elcand_12;
#DROP TABLE elcand_12;
#### USE R to list candidate names ### 

# 謝長廷 Frank Hsieh
# 蘇貞昌 Su Tseng-chang
# 馬英九 Ma Ying-jeou
# 蕭萬長 Vincent Siew

##update candidate names
UPDATE elcand_12
SET CanName = '謝長廷 Frank Hsieh'
WHERE CanName = '"謝長廷"';

UPDATE elcand_12
SET CanName = '蘇貞昌 Su Tseng-chang'
WHERE CanName = '"蘇貞昌"';

UPDATE elcand_12
SET CanName = '馬英九 Ma Ying-jeou'
WHERE CanName = '"馬英九"';

UPDATE elcand_12
SET CanName = '蕭萬長 Vincent Siew'
WHERE CanName = '"蕭萬長"';

#UPDATE elcand_12
#SET PPN = 2
#WHERE PPN = 16;

SELECT * FROM elcand_12;


#################### THREE ################################### 
#elpaty_12 is different but manually changed elcand 

#continue pulling rest of data and go to data cleaning 12 
#################### FOUR ################################### 
CREATE TABLE `vote_data`.`elprof_12` (
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/12/elprof.csv' #change
INTO TABLE elprof_12 #change
FIELDS TERMINATED BY ',';

SELECT * FROM elprof_12;

#################### FIVE ################################### 
CREATE TABLE `vote_data`.`elctks_12` (
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/12/elctks.csv' #change
INTO TABLE elctks_12 #change
FIELDS TERMINATED BY ',';

#check rows are multiple : elprof_12 22593 * 2 = 45186 elctks_12
#continue to data cleaning 12 