use vote_data;

#################### final_9 ################################### 
CREATE TABLE `vote_data`.`finalgrab_9` (
  `ValidBallot` INT(8) NULL,
  `InvalBallot` INT(8) NULL, 	
  `TotalVote` INT(8) NULL, 	
  `EligVoter` INT(8) NULL, 	
  `TotalPop` INT(8) NULL, 	
  `EligVoter/TotalPop` DECIMAL(7,2) NULL, 	
  `TotalVote/EligVoter` DECIMAL(7,2) NULL,
  #candidate names INT(8) NULL,
  `李登輝 Lee Teng-hui,連戰 Lien Chan: Kuo.Min.Tang` INT(8) NULL,
  `林洋港 Lin Yang-kang,郝柏村 Hau Pei-tsun: New.Party` INT(8) NULL,
  `陳履安 Chen Li-an,王清峰 Wang Ching-feng: Independent` INT(8) NULL,
  `彭明敏 Peng Ming-min,謝長廷 Frank Hsieh: Dem.Prog.Party` INT(8) NULL,
  `AName` CHAR(30) NULL,
  `ANameE` CHAR(30) NULL)
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/14/finalgrab_9.csv' #change
INTO TABLE finalgrab_9 #change
FIELDS TERMINATED BY ','
IGNORE 1 lines;

SELECT * FROM finalgrab_9;

#################### final_10 ################################### 
CREATE TABLE `vote_data`.`finalgrab_10` (
  `ValidBallot` INT(8) NULL,
  `InvalBallot` INT(8) NULL, 	
  `TotalVote` INT(8) NULL, 	
  `EligVoter` INT(8) NULL, 	
  `TotalPop` INT(8) NULL, 	
  `EligVoter/TotalPop` DECIMAL(7,2) NULL, 	
  `TotalVote/EligVoter` DECIMAL(7,2) NULL,
  #candidate names INT(8) NULL,
  `宋楚瑜 James Soong,張昭雄 Chang Chau-hsiung: Independent` INT(8) NULL,
  `李敖 Li Ao ,馮滬祥 Elmer Fung: New.Party` INT(8) NULL,
  `許信良 Hsu Hsin-liang,朱惠良 Josephine Chu: Independent` INT(8) NULL,
  `連戰 Lien Chan ,蕭萬長 Vincent Siew: Kuo.Min.Tang` INT(8) NULL,
  `陳水扁 Chen Shui-bian,呂秀蓮 Annette Lu: Dem.Prog.Party` INT(8) NULL,
  `AName` CHAR(30) NULL,
  `ANameE` CHAR(30) NULL)
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/14/finalgrab_10.csv' #change
INTO TABLE finalgrab_10 #change
FIELDS TERMINATED BY ','
IGNORE 1 lines;

SELECT * FROM finalgrab_10;

#################### final_11 ################################### 
CREATE TABLE `vote_data`.`finalgrab_11` (
  `ValidBallot` INT(8) NULL,
  `InvalBallot` INT(8) NULL, 	
  `TotalVote` INT(8) NULL, 	
  `EligVoter` INT(8) NULL, 	
  `TotalPop` INT(8) NULL, 	
  `EligVoter/TotalPop` DECIMAL(7,2) NULL, 	
  `TotalVote/EligVoter` DECIMAL(7,2) NULL,
  #candidate names INT(8) NULL,
  `陳水扁 Chen Shui-bian, 呂秀蓮 Annette Lu: Dem.Prog.Party` INT(8) NULL,
  `連戰 Lien Chan, 宋楚瑜 James Soong: Kuo.Min.Tang` INT(8) NULL,
  `AName` CHAR(30) NULL,
  `ANameE` CHAR(30) NULL)
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/14/finalgrab_11.csv' #change
INTO TABLE finalgrab_11 #change
FIELDS TERMINATED BY ','
IGNORE 1 lines;

SELECT * FROM finalgrab_11;


#################### final_12 ################################### 
CREATE TABLE `vote_data`.`finalgrab_12` (
  `ValidBallot` INT(8) NULL,
  `InvalBallot` INT(8) NULL, 	
  `TotalVote` INT(8) NULL, 	
  `EligVoter` INT(8) NULL, 	
  `TotalPop` INT(8) NULL, 	
  `EligVoter/TotalPop` DECIMAL(7,2) NULL, 	
  `TotalVote/EligVoter` DECIMAL(7,2) NULL,
  #candidate names INT(8) NULL,
  `馬英九 Ma Ying-jeou,蕭萬長 Vincent Siew: Kuo.Min.Tang` INT(8) NULL,
  `謝長廷 Frank Hsieh,蘇貞昌 Su Tseng-chang: Dem.Prog.Party` INT(8) NULL,
  `AName` CHAR(30) NULL,
  `ANameE` CHAR(30) NULL)
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/14/finalgrab_12.csv' #change
INTO TABLE finalgrab_12 #change
FIELDS TERMINATED BY ','
IGNORE 1 lines;

SELECT * FROM finalgrab_12;

#################### final_13 ################################### 
CREATE TABLE `vote_data`.`finalgrab_13` (
  `ValidBallot` INT(8) NULL,
  `InvalBallot` INT(8) NULL, 	
  `TotalVote` INT(8) NULL, 	
  `EligVoter` INT(8) NULL, 	
  `TotalPop` INT(8) NULL, 	
  `EligVoter/TotalPop` DECIMAL(7,2) NULL, 	
  `TotalVote/EligVoter` DECIMAL(7,2) NULL,
  #candidate names INT(8) NULL,
  `宋楚瑜 James Soong,林瑞雄 Lin Ruey-shiung: Peoples.First.Party` INT(8) NULL,
  `馬英九 Ma Ying-jeou,吳敦義 Wu Den-yih: Kuo.Min.Tang` INT(8) NULL,
  `蔡英文 Tsai Ing-wen,蘇嘉全 Su Jia-chyuan: Dem.Prog.Party` INT(8) NULL,
  `AName` CHAR(30) NULL,
  `ANameE` CHAR(30) NULL)
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/14/finalgrab_13.csv' #change
INTO TABLE finalgrab_13 #change
FIELDS TERMINATED BY ','
IGNORE 1 lines;

SELECT * FROM finalgrab_13;

#################### final_14 ################################### 
CREATE TABLE `vote_data`.`finalgrab_14` (
  `ValidBallot` INT(8) NULL,
  `InvalBallot` INT(8) NULL, 	
  `TotalVote` INT(8) NULL, 	
  `EligVoter` INT(8) NULL, 	
  `TotalPop` INT(8) NULL, 	
  `EligVoter/TotalPop` DECIMAL(7,2) NULL, 	
  `TotalVote/EligVoter` DECIMAL(7,2) NULL,
  #candidate names INT(8) NULL,
  `朱立倫 Eric Chu,王如玄 Wang Ju-hsuan: Kuo.Min.Tang` INT(8) NULL,
  `宋楚瑜 James Soong,徐欣瑩 Hsu Hsin-ying: Peoples.First.Party` INT(8) NULL,
  `蔡英文 Tsai Ing-wen,陳建仁 Chen Chien-jen: Dem.Prog.Party` INT(8) NULL,
  `AName` CHAR(30) NULL,
  `ANameE` CHAR(30) NULL)
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/14/finalgrab_14.csv' #change
INTO TABLE finalgrab_14 #change
FIELDS TERMINATED BY ','
IGNORE 1 lines;

SELECT * FROM finalgrab_14;

which district elected the winner the most times?
which candidate got the most votes from a single place? the most percentage?
area with highest voter turnout % each year?