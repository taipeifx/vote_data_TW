SHOW databases;
USE vote_data;

SHOW tables;

select @@datadir;
select @@version;
SELECT @@global.secure_file_priv;
SHOW VARIABLES LIKE "secure_file_priv"; #'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\'

#https://www.w3schools.com/sql/sql_datatypes.asp

# TEMPLATES############# ONE ###############
CREATE TABLE `vote_data`.`elbase_10` (
  `省市別` INT(2) NULL,
  `縣市別` INT(3) NULL,
  `選別` INT(2) NULL,
  `鄉鎮市區` INT(3) NULL,
  `村里別` INT(4) NULL,
  `名稱` CHAR(30) NULL)
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/10/elbase.csv' #change
INTO TABLE elbase_10 #change
FIELDS TERMINATED BY ',';

#################### TWO ################################### 
CREATE TABLE `vote_data`.`elcand_10` (
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/10/elcand.csv' #change
INTO TABLE elcand_10 #change
FIELDS TERMINATED BY ',';

#################### THREE ################################### 
CREATE TABLE `vote_data`.`elpaty_10` (
  `政黨代號` INT(3) NULL,
  `政黨名稱` VARCHAR(40) NULL)
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/10/elpaty.csv' #change
INTO TABLE elpaty_10 #change
FIELDS TERMINATED BY ',';

#################### FOUR ################################### 
CREATE TABLE `vote_data`.`elprof_10` (
  `省市別` INT(2) NULL,
  `縣市別` INT(3) NULL,
  `選區別` INT(2) NULL,
  `鄉鎮市區` INT(3) NULL,
  `村里別` INT(4) NULL,
  `投開票所` INT(4) NULL,
  `有效票` INT(8) NULL,
  `無效票` INT(8) NULL, 	
  `投票數` INT(8) NULL, 	
  `選舉人數` INT(8) NULL, 	
  `人口數` INT(8) NULL, 	
  `候選人數合計` INT(4) NULL, 	
  `當選人數合計` INT(4) NULL, 	
  `候選人數-男` INT(4) NULL, 
  `候選人數-女` INT(4) NULL, 	
  `當選人數-男`	INT(4) NULL, 	
  `當選人數-女`	INT(4) NULL, 	
  `選舉人數對人口數` DECIMAL(7,2) NULL, 	
  `投票數對選舉人數` DECIMAL(7,2) NULL, 	
  `當選人數對候選人數` DECIMAL(7,2) NULL)
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/10/elprof.csv' #change
INTO TABLE elprof_10 #change
FIELDS TERMINATED BY ',';

#################### FIVE ################################### 
CREATE TABLE `vote_data`.`elctks_10` (
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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/10/elctks.csv' #change
INTO TABLE elctks_10 #change
FIELDS TERMINATED BY ',';

#delete any table 
DROP table elctks_9;
 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/elctks.csv' #change
INTO TABLE elctks_9 #change
FIELDS TERMINATED BY ',';
#OPTIONALLY ENCLOSED BY ' '
#IGNORE 1 lines;

SELECT * FROM elbase; #change

ALTER TABLE `vote_data`.`elprof_9` 
RENAME TO  `vote_data`.`elprof` ; #these are the original chinese versions

