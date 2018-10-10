use vote_data;


#DROP TABLE elbase_14;
# ENGLISH TEMPLATES############# ONE elbase . create table elbase, load data ###############
CREATE TABLE `vote_data`.`elbase_14` (
  `V1` INT(3) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` CHAR(4) NULL,
  `AName` CHAR(30) NULL
  )
DEFAULT CHARACTER SET = utf8; #there are letters now in V5

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/14/elbase.csv' #change
INTO TABLE elbase_14 #change
FIELDS TERMINATED BY ','
IGNORE 1 lines;

CREATE TABLE elbase_141 AS 
SELECT * FROM elbase_14
ORDER BY V2 ASC, V4 ASC; #reorder

SELECT * FROM elbase_141;
DROP TABLE elbase_14;

############# ONE elbase . create elbase_14E, use R to find column to translate into english###############
CREATE TABLE `vote_data`.`elbase_14E1` (
  `AName` CHAR(30) NULL,
  `ANameE` CHAR(30) NULL
  );

##load file created in R 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/14/ANameE1.csv' #change
INTO TABLE elbase_14E1 #change
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

SELECT * FROM elbase_14E1;

# to add english translations of ANameE column to elbase_9
#join elbase_14 with elbase_14E1

CREATE TABLE elbase_14E2 AS
SELECT DISTINCT elbase_14.V1 ,elbase_14.V2 ,elbase_14.V3 ,elbase_14.V4 ,elbase_14.V5 ,elbase_14.AName ,elbase_14E1.ANameE 
FROM elbase_14
LEFT OUTER JOIN elbase_14E1
ON elbase_14.AName = elbase_14E1.AName;


SELECT * FROM elbase_14E2;
#merge above elbase_10E2 with below elbase_10

CREATE TABLE elbase_14A
SELECT DISTINCT elbase_14.V1, elbase_14.V2, elbase_14.V3, elbase_14.V4, elbase_14.V5, elbase_14.AName, elbase_14E2.ANameE 
FROM elbase_14 
LEFT OUTER JOIN elbase_14E2
ON elbase_14.AName = elbase_14E2.AName;

SELECT * FROM elbase_14A;
##continue in mysql 

#################### TWO , create elcand table with candidate names updated################################### 
CREATE TABLE `vote_data`.`elcand_14` (
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/14/elcand.csv' #change
INTO TABLE elcand_14 #change
FIELDS TERMINATED BY ',';
SELECT * FROM elcand_14;
#DROP TABLE elcand_14;
#### USE R to list candidate names ### 

1 朱立倫 Eric Chu
2 王如玄 Wang Ju-hsuan
3 蔡英文 Tsai Ing-wen
4 陳建仁 Chen Chien-jen
5 宋楚瑜 James Soong
6 徐欣瑩 Hsu Hsin-ying;

##update candidate names
UPDATE elcand_14
SET CanName = '朱立倫 Eric Chu'
WHERE CanName = '朱立倫';

UPDATE elcand_14
SET CanName = '王如玄 Wang Ju-hsuan'
WHERE CanName = '王如玄';

UPDATE elcand_14
SET CanName = '蔡英文 Tsai Ing-wen'
WHERE CanName = '蔡英文';

UPDATE elcand_14
SET CanName = '陳建仁 Chen Chien-jen'
WHERE CanName = '陳建仁';

UPDATE elcand_14
SET CanName = '宋楚瑜 James Soong'
WHERE CanName = '宋楚瑜';

UPDATE elcand_14
SET CanName = '徐欣瑩 Hsu Hsin-ying'
WHERE CanName = '徐欣瑩';

UPDATE elcand_14
SET PPN = 2
WHERE PPN = 16;

SELECT * FROM elcand_14;


#################### THREE ################################### 
#elpaty_14 is different but manually changed elcand 

#continue pulling rest of data and go to data cleaning 14 
#################### FOUR ################################### 
CREATE TABLE `vote_data`.`elprof_14` (
  `V1` INT(2) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` CHAR(4) NULL,
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/14/elprof.csv' #change
INTO TABLE elprof_14 #change
FIELDS TERMINATED BY ',';

SELECT * FROM elprof_14;

#################### FIVE ################################### 
CREATE TABLE `vote_data`.`elctks_14` (
  `V1` INT(2) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` CHAR(4) NULL,
  `PollN` INT(4) NULL,
  `CanNum` INT(4) NULL,
  `VotesGot` INT(8) NULL,
  `PerVotes` DECIMAL(7,2) NULL,
  `Win` VARCHAR(2) NULL);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/14/elctks.csv' #change
INTO TABLE elctks_14 #change
FIELDS TERMINATED BY ',';

#check rows are multiple : elprof_14 22593 * 2 = 45186 elctks_14
#continue to data cleaning 14 