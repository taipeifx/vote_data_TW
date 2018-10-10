#EXPORT TO CSV FROM RESULTS FOR CLEANER DATA

################### DATA CLEANING #############################
#1 "attach elpaty to elcand" 
CREATE TABLE cand_11 AS 
SELECT elcand_11.CanNum, elcand_11.CanName, elcand_11.Sex, elcand_11.Age, elcand_11.CurInc, elpaty_9.PParty, elcand_11.RMate
FROM elcand_11
INNER JOIN elpaty_9
ON elcand_11.PPN = elpaty_9.PPN;

SELECT * FROM cand_11;

#join multiple rows into a single column (Pres, Vice Pres Cand in same row)
CREATE TABLE cand_11att AS
SELECT CanNum, PParty,
GROUP_CONCAT(CanName) AS CanNames
FROM cand_11
GROUP BY CanNum;

SELECT * FROM cand_11att;
#DROP TABLE cand_9att;
#2 "attach this cand_11att to elctks before cleaning"
CREATE TABLE tks_cand_11 AS
SELECT elctks_11.V1 , elctks_11.V2 , elctks_11.V3 , elctks_11.V4 , elctks_11.V5 , elctks_11.PollN, elctks_11.VotesGot , cand_11att.CanNames, cand_11att.PParty
FROM elctks_11
INNER JOIN cand_11att
ON elctks_11.CanNum = cand_11att.CanNum;

SELECT * FROM tks_cand_11;
#3 "tidyr spread() on elctks: CanNum to VotesGot (CanNum1 , 2, 3, 4 with VotesGot values"
#"tidyr spread() on elctks: CanNames + PParty to VotesGot (Candidates x 4 with VotesGot values"
#done in R, on tks_cand_xx , grab back tks_cand_xxus
CREATE TABLE `vote_data`.`tks_cand_11us` (
  `V1` INT(2) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` INT(4) NULL,
  `PollN` INT(4) NULL,
  `陳水扁 Chen Shui-bian, 呂秀蓮 Annette Lu: Dem.Prog.Party` INT(8) NULL,
  `連戰 Lien Chan, 宋楚瑜 James Soong: Kuo.Min.Tang` INT(8) NULL
  )
DEFAULT CHARACTER SET = utf8;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/11/tks_cand_11us.csv' #change
INTO TABLE tks_cand_11us #change
FIELDS TERMINATED BY ','
IGNORE 1 lines; #ignore column names

SELECT * FROM tks_cand_11us;

#4 "clean up elprof as elprof_9c and attach tks_cand_9us to it"
CREATE TABLE elprof_11c AS
SELECT elprof_11.V1, elprof_11.V2, elprof_11.V3, elprof_11.V4, elprof_11.V5, elprof_11.PollN, elprof_11.ValidBallot, elprof_11.InvalBallot, 
elprof_11.TotalVote, elprof_11.EligVoter, elprof_11.TotalPop, elprof_11.PerEligVoter, elprof_11.PerActVote	
FROM elprof_11;

SELECT * FROM elprof_11c;

#attaching elprof_9c and tks_cand_9us
CREATE TABLE prof_tks_cand_11 AS
SELECT elprof_11c.V1, elprof_11c.V2, elprof_11c.V3, elprof_11c.V4, elprof_11c.V5, elprof_11c.PollN, elprof_11c.ValidBallot, elprof_11c.InvalBallot, 
elprof_11c.TotalVote, elprof_11c.EligVoter, elprof_11c.TotalPop, elprof_11c.PerEligVoter, elprof_11c.PerActVote,
tks_cand_11us.`陳水扁 Chen Shui-bian, 呂秀蓮 Annette Lu: Dem.Prog.Party`,
tks_cand_11us.`連戰 Lien Chan, 宋楚瑜 James Soong: Kuo.Min.Tang`
FROM elprof_11c
INNER JOIN tks_cand_11us
ON elprof_11c.V1 = tks_cand_11us.V1 AND elprof_11c.V2 = tks_cand_11us.V2 AND elprof_11c.V3 = tks_cand_11us.V3 AND 
elprof_11c.V4 = tks_cand_11us.V4 AND elprof_11c.V5 = tks_cand_11us.V5 AND elprof_11c.PollN = tks_cand_11us.PollN;

SELECT * FROM prof_tks_cand_11;


#5 "attach elbase last?" yes, attach elbase_9a to prof_tks_cand_9 on V1:V5. selecting both elbase_9a.AName and elbase_9a.ANameE
SELECT * FROM elbase_11a;
#CREATE TABLE final_11 AS
SELECT DISTINCT prof_tks_cand_11.PollN, prof_tks_cand_11.ValidBallot, prof_tks_cand_11.InvalBallot, 
prof_tks_cand_11.TotalVote, prof_tks_cand_11.EligVoter, prof_tks_cand_11.TotalPop, prof_tks_cand_11.PerEligVoter, prof_tks_cand_11.PerActVote,
prof_tks_cand_11.`陳水扁 Chen Shui-bian, 呂秀蓮 Annette Lu: Dem.Prog.Party`,
prof_tks_cand_11.`連戰 Lien Chan, 宋楚瑜 James Soong: Kuo.Min.Tang`,
elbase_11a.AName, elbase_11a.ANameE
FROM prof_tks_cand_11
INNER JOIN elbase_11a
ON prof_tks_cand_11.V1 = elbase_11a.V1 AND prof_tks_cand_11.V2 = elbase_11a.V2 AND prof_tks_cand_11.V3 = elbase_11a.V3 AND prof_tks_cand_11.V4 = elbase_11a.V4 AND prof_tks_cand_11.V5 = elbase_11a.V5;
#select distinct for 20503 rows return, there are 33? repeats for some reason




















