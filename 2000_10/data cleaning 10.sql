#EXPORT TO CSV FROM RESULTS FOR CLEANER DATA

################### DATA CLEANING #############################
#1 "attach elpaty to elcand" 
CREATE TABLE cand_10 AS 
SELECT elcand_10.CanNum, elcand_10.CanName, elcand_10.Sex, elcand_10.Age, elcand_10.CurInc, elpaty_9.PParty, elcand_10.RMate
FROM elcand_10
INNER JOIN elpaty_9
ON elcand_10.PPN = elpaty_9.PPN;

SELECT * FROM cand_10;

#join multiple rows into a single column (Pres, Vice Pres Cand in same row)
CREATE TABLE cand_10att AS
SELECT CanNum, PParty,
GROUP_CONCAT(CanName) AS CanNames
FROM cand_10
GROUP BY CanNum;

SELECT * FROM cand_10;
#DROP TABLE cand_9att;
#2 "attach this cand_10att to elctks before cleaning"
CREATE TABLE tks_cand_10 AS
SELECT elctks_10.V1 , elctks_10.V2 , elctks_10.V3 , elctks_10.V4 , elctks_10.V5 , elctks_10.PollN, elctks_10.VotesGot , cand_10att.CanNames, cand_10att.PParty
FROM elctks_10
INNER JOIN cand_10att
ON elctks_10.CanNum = cand_10att.CanNum;

#3 "tidyr spread() on elctks: CanNum to VotesGot (CanNum1 , 2, 3, 4 with VotesGot values"
#"tidyr spread() on elctks: CanNames + PParty to VotesGot (Candidates x 4 with VotesGot values"
#done in R, on tks_cand_xx , grab back tks_cand_xxus
CREATE TABLE `vote_data`.`tks_cand_10us` (
  `V1` INT(2) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` INT(4) NULL,
  `PollN` INT(4) NULL,
  `宋楚瑜 James Soong,張昭雄 Chang Chau-hsiung: Independent` INT(8) NULL,
  `李敖 Li Ao ,馮滬祥 Elmer Fung: New.Party` INT(8) NULL,
  `許信良 Hsu Hsin-liang,朱惠良 Josephine Chu: Independent` INT(8) NULL,
  `連戰 Lien Chan ,蕭萬長 Vincent Siew: Kuo.Min.Tang` INT(8) NULL,
  `陳水扁 Chen Shui-bian,呂秀蓮 Annette Lu: Dem.Prog.Party` INT(8) NULL)
DEFAULT CHARACTER SET = utf8;

# [7] "宋楚瑜 James Soong,張昭雄 Chang Chau-hsiung: Independent" "李敖 Li Ao ,馮滬祥 Elmer Fung: New.Party"                
# [9] "許信良 Hsu Hsin-liang,朱惠良 Josephine Chu: Independent"  "連戰 Lien Chan ,蕭萬長 Vincent Siew: Kuo.Min.Tang"       
#[11] "陳水扁 Chen Shui-bian,呂秀蓮 Annette Lu: Dem.Prog.Party" 

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/10/tks_cand_10us.csv' #change
INTO TABLE tks_cand_10us #change
FIELDS TERMINATED BY ','
IGNORE 1 lines; #ignore column names

SELECT * FROM tks_cand_10us;

#4 "clean up elprof as elprof_9c and attach tks_cand_9us to it"
CREATE TABLE elprof_10c AS
SELECT elprof_10.V1, elprof_10.V2, elprof_10.V3, elprof_10.V4, elprof_10.V5, elprof_10.PollN, elprof_10.ValidBallot, elprof_10.InvalBallot, 
elprof_10.TotalVote, elprof_10.EligVoter, elprof_10.TotalPop, elprof_10.PerEligVoter, elprof_10.PerActVote	
FROM elprof_10;

SELECT * FROM elprof_10c;

#attaching elprof_9c and tks_cand_9us
CREATE TABLE prof_tks_cand_10 AS
SELECT elprof_10c.V1, elprof_10c.V2, elprof_10c.V3, elprof_10c.V4, elprof_10c.V5, elprof_10c.PollN, elprof_10c.ValidBallot, elprof_10c.InvalBallot, 
elprof_10c.TotalVote, elprof_10c.EligVoter, elprof_10c.TotalPop, elprof_10c.PerEligVoter, elprof_10c.PerActVote,
tks_cand_10us.`宋楚瑜 James Soong,張昭雄 Chang Chau-hsiung: Independent`,
tks_cand_10us.`李敖 Li Ao ,馮滬祥 Elmer Fung: New.Party`,
tks_cand_10us.`許信良 Hsu Hsin-liang,朱惠良 Josephine Chu: Independent`,
tks_cand_10us.`連戰 Lien Chan ,蕭萬長 Vincent Siew: Kuo.Min.Tang`,
tks_cand_10us.`陳水扁 Chen Shui-bian,呂秀蓮 Annette Lu: Dem.Prog.Party`
FROM elprof_10c
INNER JOIN tks_cand_10us
ON elprof_10c.V1 = tks_cand_10us.V1 AND elprof_10c.V2 = tks_cand_10us.V2 AND elprof_10c.V3 = tks_cand_10us.V3 AND 
elprof_10c.V4 = tks_cand_10us.V4 AND elprof_10c.V5 = tks_cand_10us.V5 AND elprof_10c.PollN = tks_cand_10us.PollN;

SELECT * FROM prof_tks_cand_10;


#5 "attach elbase last?" yes, attach elbase_9a to prof_tks_cand_9 on V1:V5. selecting both elbase_9a.AName and elbase_9a.ANameE
SELECT * FROM elbase_10a;
#CREATE TABLE final_10 AS
SELECT DISTINCT prof_tks_cand_10.PollN, prof_tks_cand_10.ValidBallot, prof_tks_cand_10.InvalBallot, 
prof_tks_cand_10.TotalVote, prof_tks_cand_10.EligVoter, prof_tks_cand_10.TotalPop, prof_tks_cand_10.PerEligVoter, prof_tks_cand_10.PerActVote,
prof_tks_cand_10.`宋楚瑜 James Soong,張昭雄 Chang Chau-hsiung: Independent`,
prof_tks_cand_10.`李敖 Li Ao ,馮滬祥 Elmer Fung: New.Party`,
prof_tks_cand_10.`許信良 Hsu Hsin-liang,朱惠良 Josephine Chu: Independent`,
prof_tks_cand_10.`連戰 Lien Chan ,蕭萬長 Vincent Siew: Kuo.Min.Tang`,
prof_tks_cand_10.`陳水扁 Chen Shui-bian,呂秀蓮 Annette Lu: Dem.Prog.Party`,
elbase_10a.AName, elbase_10a.ANameE
FROM prof_tks_cand_10
INNER JOIN elbase_10a
ON prof_tks_cand_10.V1 = elbase_10a.V1 AND prof_tks_cand_10.V2 = elbase_10a.V2 AND prof_tks_cand_10.V3 = elbase_10a.V3 AND prof_tks_cand_10.V4 = elbase_10a.V4 AND prof_tks_cand_10.V5 = elbase_10a.V5;
#select distinct for 20503 rows return, there are 33? repeats for some reason




















