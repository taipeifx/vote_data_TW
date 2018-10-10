use vote_data;


# ENGLISH TEMPLATES############# ONE ###############
CREATE TABLE `vote_data`.`elbase_10` (
  `V1` INT(3) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` INT(4) NULL,
  `AName` CHAR(30) NULL
  )
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/10/elbase.csv' #change
INTO TABLE elbase_10 #change
FIELDS TERMINATED BY ',';
#IGNORE 1 lines;

SELECT DISTINCT * FROM elbase_9a WHERE V5 = 0;

##check to see difference between elbase9&10.

SELECT DISTINCT *  #interesting. maybe the second elections they improved the voting process and added more districts?
FROM elbase_9a
LEFT OUTER JOIN elbase_10
ON elbase_9a.V1 = elbase_10.V1 AND elbase_9a.V2 = elbase_10.V2 AND elbase_9a.V3 = elbase_10.V3 AND elbase_9a.V4 = elbase_10.V4 AND elbase_9a.V5 = elbase_10.V5
WHERE elbase_9a.V5 = 0; #-1 alishan township in 2010

SELECT * FROM prof_tks_cand_9;



CREATE TABLE `vote_data`.`elbase_10E` (
  `ANameE` CHAR(30) NULL
  );

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/10/AName10E.csv' #change
INTO TABLE elbase_10E #change
FIELDS TERMINATED BY ',';
#IGNORE 1 lines;
SELECT * FROM elbase_10E;

# to add english translations of ANameE column to elbase_9
# 1. add null column to ellbase_9att which is a table of english translations
# 2. create new table with information from both _9 and _9att, using pseudo row values
# #. new table is LEFT OUTER JOINED to original table on AName = AName

ALTER TABLE elbase_10E  #add a NULL column
ADD COLUMN V4 CHAR(30) AFTER ANameE; #to sort 

CREATE TABLE elbase_10E2 AS #create new table from pseudo tables
SELECT T1.AName, T2.ANameE from
(select *, row_number() over (order by V5) as rn from elbase_10) T1  #pseudo value row num, V5 to match up
,
(select *, row_number() over (order by V4) as rn from elbase_10E) T2 #pseudo value row num
WHERE T1.rn = T2.rn; #row numbers = each other

SELECT * FROM elbase_10E2;
#merge above elbase_10E2 with below elbase_10

CREATE TABLE elbase_10A 
SELECT DISTINCT elbase_10.V1, elbase_10.V2, elbase_10.V3, elbase_10.V4, elbase_10.V5, elbase_10.AName, elbase_10E2.ANameE 
FROM elbase_10 
LEFT OUTER JOIN elbase_10E2
ON elbase_10.AName = elbase_10E2.AName;

#################### TWO ################################### 
CREATE TABLE `vote_data`.`elcand_10` (
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/10/elcand.csv' #change
INTO TABLE elcand_10 #change
FIELDS TERMINATED BY ',';
宋楚瑜 James Soong
張昭雄 Chang Chau-hsiung 	
連戰 Lien Chan 
蕭萬長 Vincent Siew
李敖 Li Ao  
馮滬祥 Elmer Fung
許信良	Hsu Hsin-liang
朱惠良 Josephine Chu
陳水扁 Chen Shui-bian
呂秀蓮 Annette Lu
;
##update candidate names
UPDATE elcand_10
SET CanName = '宋楚瑜 James Soong'
WHERE CanName = '宋楚瑜';

UPDATE elcand_10
SET CanName = '張昭雄 Chang Chau-hsiung'
WHERE CanName = '張昭雄';

UPDATE elcand_10
SET CanName = '連戰 Lien Chan '
WHERE CanName = '連戰';

UPDATE elcand_10
SET CanName = '蕭萬長 Vincent Siew'
WHERE CanName = '蕭萬長';

UPDATE elcand_10
SET CanName = '李敖 Li Ao '
WHERE CanName = '李敖';

UPDATE elcand_10
SET CanName = '馮滬祥 Elmer Fung'
WHERE CanName = '馮滬祥';

UPDATE elcand_10
SET CanName = '許信良 Hsu Hsin-liang'
WHERE CanName = '許信良';

UPDATE elcand_10
SET CanName = '朱惠良 Josephine Chu'
WHERE CanName = '朱惠良';

UPDATE elcand_10
SET CanName = '陳水扁 Chen Shui-bian'
WHERE CanName = '陳水扁';

UPDATE elcand_10
SET CanName = '呂秀蓮 Annette Lu'
WHERE CanName = '呂秀蓮';

SELECT * FROM elcand_10;
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
CREATE TABLE `vote_data`.`elprof_10` (
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/10/elprof.csv' #change
INTO TABLE elprof_10 #change
FIELDS TERMINATED BY ',';

SELECT * FROM elprof_10;

#################### FIVE ################################### 
CREATE TABLE `vote_data`.`elctks_10` (
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/10/elctks.csv' #change
INTO TABLE elctks_10 #change
FIELDS TERMINATED BY ',';

#delete any table 
#DROP table elbase_9;

SELECT * FROM elctks_10;


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