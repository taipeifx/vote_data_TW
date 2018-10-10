# ENGLISH TEMPLATES############# ONE ###############
CREATE TABLE `vote_data`.`elbase_9` (
  `V1` INT(3) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` INT(4) NULL,
  `AName` CHAR(30) NULL
  )
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/9/elbase.csv' #change
INTO TABLE elbase_9 #change
FIELDS TERMINATED BY ',';
IGNORE 1 lines;

CREATE TABLE `vote_data`.`elbase_9att` (
  `ANameE` VARCHAR(30) NULL
  );

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/9/elbaseatt.csv' #change
INTO TABLE elbase_9att #change
FIELDS TERMINATED BY ','
IGNORE 1 lines;

# to add english translations of ANameE column to elbase_9
# 1. add null column to ellbase_9att which is a table of english translations
# 2. create new table with information from both _9 and _9att, using pseudo row values
# #. new table is LEFT OUTER JOINED to original table on AName = AName

ALTER TABLE elbase_9att  #add a NULL column
ADD COLUMN V4 CHAR(30) AFTER ANameE; #to sort 

CREATE TABLE elbase_9E AS #create new table from pseudo tables
SELECT T1.AName, T2.ANameE from
(select *, row_number() over (order by V5) as rn from elbase_9) T1  #pseudo value row num, V5 to match up
,
(select *, row_number() over (order by V4) as rn from elbase_9att) T2 #pseudo value row num
WHERE T1.rn = T2.rn; #row numbers = each other
#merge above elbase_9E with below elbase_9

CREATE TABLE elbase_9A SELECT elbase_9.V1, elbase_9.V2, elbase_9.V3, elbase_9.V4, elbase_9.V5, elbase_9.AName, elbase_9E.ANameE FROM elbase_9 LEFT OUTER JOIN elbase_9E
ON elbase_9.AName = elbase_9E.AName;

###
select * from elbase_9E;
SELECT * FROM elbase_9A;
#DROP TABLE elbase_9A;

#################### TWO ################################### 
CREATE TABLE `vote_data`.`elcand_9` (
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/9/elcand.csv' #change
INTO TABLE elcand_9 #change
FIELDS TERMINATED BY ',';

##update candidate names
UPDATE elcand_9
SET CanName = '陳履安 Chen Li-an'
WHERE CanName = '陳履安';

UPDATE elcand_9
SET CanName = '王清峰 Wang Ching-feng'
WHERE CanName = '王清峰';

UPDATE elcand_9
SET CanName = '李登輝 Lee Teng-hui'
WHERE CanName = '李登輝';

UPDATE elcand_9
SET CanName = '連戰 Lien Chan'
WHERE CanName = '連戰';

UPDATE elcand_9
SET CanName = '彭明敏 Peng Ming-min'
WHERE CanName = '彭明敏';

UPDATE elcand_9
SET CanName = '謝長廷 Frank Hsieh'
WHERE CanName = '謝長廷';

UPDATE elcand_9
SET CanName = '林洋港 Lin Yang-kang'
WHERE CanName = '林洋港';

UPDATE elcand_9
SET CanName = '郝柏村 Hau Pei-tsun'
WHERE CanName = '郝柏村';

#陳履安 Chen Li-an
#王清峰 Wang Ching-feng
#李登輝 Lee Teng-hui
#連戰 Lien Chan
#彭明敏 Peng Ming-min
#謝長廷 Frank Hsieh
#林洋港 Lin Yang-kang
#郝柏村 Hau Pei-tsun

UPDATE elcand_9
SET PPN = 3
WHERE CanNum = 4; #change two PPN numbers at once 

SELECT * FROM elcand_9;
#################### THREE ################################### 
CREATE TABLE `vote_data`.`elpaty_9` (
  `PPN` INT(3) NULL,
  `PParty` VARCHAR(40) NULL)
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/9/elpaty.csv' #change
INTO TABLE elpaty_9 #change
FIELDS TERMINATED BY ',';

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

SELECT * FROM elpaty_9;
#################### FOUR ################################### 
CREATE TABLE `vote_data`.`elprof_9` (
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/9/elprof.csv' #change
INTO TABLE elprof_9 #change
FIELDS TERMINATED BY ',';

SELECT * FROM elprof_9;

#################### FIVE ################################### 
CREATE TABLE `vote_data`.`elctks_9` (
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/9/elctks.csv' #change
INTO TABLE elctks_9 #change
FIELDS TERMINATED BY ',';

#delete any table 
#DROP table elbase_9;

SELECT * FROM elctks_9;



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