#EXPORT TO CSV FROM RESULTS FOR CLEANER DATA

################### DATA CLEANING #############################
#1 "attach elpaty to elcand" 
CREATE TABLE cand_9 AS 
SELECT elcand_9.CanNum, elcand_9.CanName, elcand_9.Sex, elcand_9.Age, elcand_9.CurInc, elpaty_9.PParty, elcand_9.RMate
FROM elcand_9
INNER JOIN elpaty_9
ON elcand_9.PPN = elpaty_9.PPN;

SELECT * FROM cand_9;

#join multiple rows into a single column (Pres, Vice Pres Cand in same row)
#CREATE TABLE cand_9att AS
SELECT CanNum, PParty,
GROUP_CONCAT(CanName) AS CanNames
FROM cand_9
GROUP BY CanNum;

SELECT * FROM cand_9;
#DROP TABLE cand_9att;
#2 "attach this cand_9att to elctks before cleaning"
#CREATE TABLE tks_cand_9 AS
SELECT elctks_9.V1 , elctks_9.V2 , elctks_9.V3 , elctks_9.V4 , elctks_9.V5 , elctks_9.PollN, elctks_9.VotesGot , cand_9att.CanNames, cand_9att.PParty
FROM elctks_9
INNER JOIN cand_9att
ON elctks_9.CanNum = cand_9att.CanNum;

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

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/9/tks_cand_9us.csv' #change
INTO TABLE tks_cand_9us #change
FIELDS TERMINATED BY ','
IGNORE 1 lines; #ignore column names

SELECT * FROM tks_cand_9us;

#4 "clean up elprof as elprof_9c and attach tks_cand_9us to it"
CREATE TABLE elprof_9c AS
SELECT elprof_9.V1, elprof_9.V2, elprof_9.V3, elprof_9.V4, elprof_9.V5, elprof_9.PollN, elprof_9.ValidBallot, elprof_9.InvalBallot, 
elprof_9.TotalVote, elprof_9.EligVoter, elprof_9.TotalPop, elprof_9.PerEligVoter, elprof_9.PerActVote	
FROM elprof_9;

#attaching elprof_9c and tks_cand_9us
CREATE TABLE prof_tks_cand_9 AS
SELECT elprof_9c.V1, elprof_9c.V2, elprof_9c.V3, elprof_9c.V4, elprof_9c.V5, elprof_9c.PollN, elprof_9c.ValidBallot, elprof_9c.InvalBallot, 
elprof_9c.TotalVote, elprof_9c.EligVoter, elprof_9c.TotalPop, elprof_9c.PerEligVoter, elprof_9c.PerActVote,
tks_cand_9us.`李登輝 Lee Teng-hui,連戰 Lien Chan: Kuo.Min.Tang`,
tks_cand_9us.`林洋港 Lin Yang-kang,郝柏村 Hau Pei-tsun: New.Party`,
tks_cand_9us.`陳履安 Chen Li-an,王清峰 Wang Ching-feng: Independent`,
tks_cand_9us.`彭明敏 Peng Ming-min,謝長廷 Frank Hsieh: Dem.Prog.Party`
FROM elprof_9c
INNER JOIN tks_cand_9us
ON elprof_9c.V1 = tks_cand_9us.V1 AND elprof_9c.V2 = tks_cand_9us.V2 AND elprof_9c.V3 = tks_cand_9us.V3 AND elprof_9c.V4 = tks_cand_9us.V4 AND elprof_9c.V5 = tks_cand_9us.V5 AND elprof_9c.PollN = tks_cand_9us.PollN;

SELECT * FROM prof_tks_cand_9;


#5 "attach elbase last?" yes, attach elbase_9a to prof_tks_cand_9 on V1:V5. selecting both elbase_9a.AName and elbase_9a.ANameE
SELECT * FROM elbase_9a;
CREATE TABLE final_9 AS
SELECT DISTINCT prof_tks_cand_9.PollN, prof_tks_cand_9.ValidBallot, prof_tks_cand_9.InvalBallot, 
prof_tks_cand_9.TotalVote, prof_tks_cand_9.EligVoter, prof_tks_cand_9.TotalPop, prof_tks_cand_9.PerEligVoter, prof_tks_cand_9.PerActVote,
prof_tks_cand_9.`李登輝 Lee Teng-hui,連戰 Lien Chan: Kuo.Min.Tang`,
prof_tks_cand_9.`林洋港 Lin Yang-kang,郝柏村 Hau Pei-tsun: New.Party`,
prof_tks_cand_9.`陳履安 Chen Li-an,王清峰 Wang Ching-feng: Independent`,
prof_tks_cand_9.`彭明敏 Peng Ming-min,謝長廷 Frank Hsieh: Dem.Prog.Party`,
elbase_9a.AName, elbase_9a.ANameE
FROM prof_tks_cand_9
INNER JOIN elbase_9a
ON prof_tks_cand_9.V1 = elbase_9a.V1 AND prof_tks_cand_9.V2 = elbase_9a.V2 AND prof_tks_cand_9.V3 = elbase_9a.V3 AND prof_tks_cand_9.V4 = elbase_9a.V4 AND prof_tks_cand_9.V5 = elbase_9a.V5;
#select distinct for 20503 rows return, there are 33? repeats for some reason


###
CREATE TABLE elbase_9E AS #create new table from pseudo tables
SELECT T1.AName, T2.ANameE from
(select *, row_number() over (order by V5) as rn from elbase_9) T1  #pseudo value row num, V5 to match up
,
(select *, row_number() over (order by V4) as rn from elbase_9att) T2 #pseudo value row num
WHERE T1.rn = T2.rn; #row numbers = each other
#merge above elbase_9E with below elbase_9

CREATE TABLE elbase_9A SELECT elbase_9.V1, elbase_9.V2, elbase_9.V3, elbase_9.V4, elbase_9.V5, elbase_9.AName, elbase_9E.ANameE FROM elbase_9 LEFT OUTER JOIN elbase_9E
ON elbase_9.AName = elbase_9E.AName;

################################
ALTER TABLE elbase_9att  #add a NULL column
ADD COLUMN V4 CHAR(30) AFTER ANameE; #to sort 





















