#EXPORT TO CSV FROM RESULTS FOR CLEANER DATA

################### DATA CLEANING #############################
#1 "attach elpaty to elcand"  
#use elpaty 9 unless things change
CREATE TABLE cand_12 AS 
SELECT elcand_12.CanNum, elcand_12.CanName, elcand_12.Sex, elcand_12.Age, elcand_12.CurInc, elpaty_9.PParty, elcand_12.RMate
FROM elcand_12
INNER JOIN elpaty_9
ON elcand_12.PPN = elpaty_9.PPN;

SELECT * FROM cand_12;

#join multiple rows into a single column (Pres, Vice Pres Cand in same row)
CREATE TABLE cand_12att AS
SELECT CanNum, PParty,
GROUP_CONCAT(CanName) AS CanNames
FROM cand_12
GROUP BY CanNum;

SELECT * FROM cand_12att;

#DROP TABLE cand_9att;

#2 "attach this cand_11att to elctks before cleaning in R"
CREATE TABLE tks_cand_12 AS
SELECT elctks_12.V1 , elctks_12.V2 , elctks_12.V3 , elctks_12.V4 , elctks_12.V5 , elctks_12.PollN, elctks_12.VotesGot , cand_12att.CanNames, cand_12att.PParty
FROM elctks_12
INNER JOIN cand_12att
ON elctks_12.CanNum = cand_12att.CanNum;

SELECT * FROM tks_cand_12;
# save this as a file tks_cand_12 for use in R, and head back to R for : 
# tidyr spread() on elctks: CanNames + PParty to VotesGot (Candidates x 4 with VotesGot values)
# done in R, on tks_cand_xx 

#grab back tks_cand_xxus

## CREATE TABLE TO LOAD tks_cand_xxus, edit column names ##
CREATE TABLE `vote_data`.`tks_cand_12us` (
  `V1` INT(2) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` INT(4) NULL,
  `PollN` INT(4) NULL,
  `馬英九 Ma Ying-jeou,蕭萬長 Vincent Siew: Kuo.Min.Tang` INT(8) NULL,
  `謝長廷 Frank Hsieh,蘇貞昌 Su Tseng-chang: Dem.Prog.Party` INT(8) NULL
  )
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/12/tks_cand_12us.csv' #change
INTO TABLE tks_cand_12us #change
FIELDS TERMINATED BY ','
IGNORE 1 lines; #ignore column names

SELECT * FROM tks_cand_12us;

#4 "clean up elprof as elprof_xxc and attach tks_cand_xxus to it"
CREATE TABLE elprof_12c AS
SELECT elprof_12.V1, elprof_12.V2, elprof_12.V3, elprof_12.V4, elprof_12.V5, elprof_12.PollN, elprof_12.ValidBallot, elprof_12.InvalBallot, 
elprof_12.TotalVote, elprof_12.EligVoter, elprof_12.TotalPop, elprof_12.PerEligVoter, elprof_12.PerActVote	
FROM elprof_12;

SELECT * FROM elprof_12c;

#attaching elprof_xxc and tks_cand_xxus
CREATE TABLE prof_tks_cand_12 AS
SELECT elprof_12c.V1, elprof_12c.V2, elprof_12c.V3, elprof_12c.V4, elprof_12c.V5, elprof_12c.PollN, elprof_12c.ValidBallot, elprof_12c.InvalBallot, 
elprof_12c.TotalVote, elprof_12c.EligVoter, elprof_12c.TotalPop, elprof_12c.PerEligVoter, elprof_12c.PerActVote,
tks_cand_12us.`馬英九 Ma Ying-jeou,蕭萬長 Vincent Siew: Kuo.Min.Tang`,
tks_cand_12us.`謝長廷 Frank Hsieh,蘇貞昌 Su Tseng-chang: Dem.Prog.Party`
FROM elprof_12c
INNER JOIN tks_cand_12us
ON elprof_12c.V1 = tks_cand_12us.V1 AND elprof_12c.V2 = tks_cand_12us.V2 AND elprof_12c.V3 = tks_cand_12us.V3 AND 
elprof_12c.V4 = tks_cand_12us.V4 AND elprof_12c.V5 = tks_cand_12us.V5 AND elprof_12c.PollN = tks_cand_12us.PollN;

SELECT * FROM prof_tks_cand_12;


#5 finally, attach elbase_xxa to prof_tks_cand_xx on V1:V5. selecting both elbase_xxa.AName and elbase_xxa.ANameE
#SELECT * FROM elbase_12a;
CREATE TABLE final_12 AS
SELECT DISTINCT prof_tks_cand_12.PollN, prof_tks_cand_12.ValidBallot, prof_tks_cand_12.InvalBallot, 
prof_tks_cand_12.TotalVote, prof_tks_cand_12.EligVoter, prof_tks_cand_12.TotalPop, prof_tks_cand_12.PerEligVoter, prof_tks_cand_12.PerActVote,
prof_tks_cand_12.`馬英九 Ma Ying-jeou,蕭萬長 Vincent Siew: Kuo.Min.Tang`,
prof_tks_cand_12.`謝長廷 Frank Hsieh,蘇貞昌 Su Tseng-chang: Dem.Prog.Party`,
elbase_12a.AName, elbase_12a.ANameE
FROM prof_tks_cand_12
INNER JOIN elbase_12a
ON prof_tks_cand_12.V1 = elbase_12a.V1 AND prof_tks_cand_12.V2 = elbase_12a.V2 AND prof_tks_cand_12.V3 = elbase_12a.V3 AND prof_tks_cand_12.V4 = elbase_12a.V4 AND prof_tks_cand_12.V5 = elbase_12a.V5;

#Finished. head back to R 



















