#EXPORT TO CSV FROM RESULTS FOR CLEANER DATA
### update a single row's column

################### DATA CLEANING #############################
#1 "attach elpaty to elcand"  
#use elpaty 9 unless things change
CREATE TABLE cand_14 AS 
SELECT elcand_14.CanNum, elcand_14.CanName, elcand_14.Sex, elcand_14.Age, elcand_14.CurInc, elpaty_9.PParty, elcand_14.RMate
FROM elcand_14
INNER JOIN elpaty_9
ON elcand_14.PPN = elpaty_9.PPN;

SELECT * FROM cand_14;

#join multiple rows into a single column (Pres, Vice Pres Cand in same row)
CREATE TABLE cand_14att AS
SELECT CanNum, PParty,
GROUP_CONCAT(CanName) AS CanNames
FROM cand_14
GROUP BY CanNum;

SELECT * FROM cand_14att;

#DROP TABLE cand_9att;

#2 "attach this cand_11att to elctks before cleaning in R"
CREATE TABLE tks_cand_14 AS
SELECT elctks_14.V1 , elctks_14.V2 , elctks_14.V3 , elctks_14.V4 , elctks_14.V5 , elctks_14.PollN, elctks_14.VotesGot , cand_14att.CanNames, cand_14att.PParty
FROM elctks_14
INNER JOIN cand_14att
ON elctks_14.CanNum = cand_14att.CanNum;

SELECT * FROM tks_cand_14;
# save this as a file tks_cand_14 for use in R, and head back to R for : 
# tidyr spread() on elctks: CanNames + PParty to VotesGot (Candidates x 4 with VotesGot values)
# done in R, on tks_cand_xx 

#grab back tks_cand_xxus

#[7] "朱立倫 Eric Chu,王如玄 Wang Ju-hsuan: Kuo.Min.Tang"          
#[8] "宋楚瑜 James Soong,徐欣瑩 Hsu Hsin-ying: Peoples.First.Party"
#[9] "蔡英文 Tsai Ing-wen,陳建仁 Chen Chien-jen: Dem.Prog.Party"      

## CREATE TABLE TO LOAD tks_cand_xxus, edit column names ##
CREATE TABLE `vote_data`.`tks_cand_14us` (
  `V1` INT(2) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` CHAR(4) NULL,
  `PollN` INT(4) NULL,
  `朱立倫 Eric Chu,王如玄 Wang Ju-hsuan: Kuo.Min.Tang` INT(8) NULL,
  `宋楚瑜 James Soong,徐欣瑩 Hsu Hsin-ying: Peoples.First.Party` INT(8) NULL,
  `蔡英文 Tsai Ing-wen,陳建仁 Chen Chien-jen: Dem.Prog.Party` INT(8) NULL
  )
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/14/tks_cand_14us.csv' #change
INTO TABLE tks_cand_14us #change
FIELDS TERMINATED BY ','
IGNORE 1 lines; #ignore column names

SELECT * FROM tks_cand_14us;

#4 "clean up elprof as elprof_xxc and attach tks_cand_xxus to it"
CREATE TABLE elprof_14c AS
SELECT elprof_14.V1, elprof_14.V2, elprof_14.V3, elprof_14.V4, elprof_14.V5, elprof_14.PollN, elprof_14.ValidBallot, elprof_14.InvalBallot, 
elprof_14.TotalVote, elprof_14.EligVoter, elprof_14.TotalPop, elprof_14.PerEligVoter, elprof_14.PerActVote	
FROM elprof_14;

SELECT * FROM elprof_14c;

#attaching elprof_xxc and tks_cand_xxus
CREATE TABLE prof_tks_cand_14 AS
SELECT elprof_14c.V1, elprof_14c.V2, elprof_14c.V3, elprof_14c.V4, elprof_14c.V5, elprof_14c.PollN, elprof_14c.ValidBallot, elprof_14c.InvalBallot, 
elprof_14c.TotalVote, elprof_14c.EligVoter, elprof_14c.TotalPop, elprof_14c.PerEligVoter, elprof_14c.PerActVote,
tks_cand_14us.`朱立倫 Eric Chu,王如玄 Wang Ju-hsuan: Kuo.Min.Tang`,
tks_cand_14us.`宋楚瑜 James Soong,徐欣瑩 Hsu Hsin-ying: Peoples.First.Party`,
tks_cand_14us.`蔡英文 Tsai Ing-wen,陳建仁 Chen Chien-jen: Dem.Prog.Party`
FROM elprof_14c
INNER JOIN tks_cand_14us
ON elprof_14c.V1 = tks_cand_14us.V1 AND elprof_14c.V2 = tks_cand_14us.V2 AND elprof_14c.V3 = tks_cand_14us.V3 AND 
elprof_14c.V4 = tks_cand_14us.V4 AND elprof_14c.V5 = tks_cand_14us.V5 AND elprof_14c.PollN = tks_cand_14us.PollN;

SELECT * FROM prof_tks_cand_14;


#5 finally, attach elbase_xxa to prof_tks_cand_xx on V1:V5. selecting both elbase_xxa.AName and elbase_xxa.ANameE
#SELECT * FROM elbase_14a;
CREATE TABLE final_14 AS
SELECT prof_tks_cand_14.PollN, prof_tks_cand_14.ValidBallot, prof_tks_cand_14.InvalBallot, 
prof_tks_cand_14.TotalVote, prof_tks_cand_14.EligVoter, prof_tks_cand_14.TotalPop, prof_tks_cand_14.PerEligVoter, prof_tks_cand_14.PerActVote,
prof_tks_cand_14.`朱立倫 Eric Chu,王如玄 Wang Ju-hsuan: Kuo.Min.Tang`,
prof_tks_cand_14.`宋楚瑜 James Soong,徐欣瑩 Hsu Hsin-ying: Peoples.First.Party`,
prof_tks_cand_14.`蔡英文 Tsai Ing-wen,陳建仁 Chen Chien-jen: Dem.Prog.Party`,
elbase_14A.AName, elbase_14A.ANameE
FROM prof_tks_cand_14
INNER JOIN elbase_14A
ON prof_tks_cand_14.V1 = elbase_14A.V1 AND prof_tks_cand_14.V2 = elbase_14A.V2 AND prof_tks_cand_14.V4 = elbase_14A.V4 AND prof_tks_cand_14.V5 = elbase_14A.V5; #there are values in V3

SELECT * FROM final_14; #save into R

#Finished. head back to R 



















