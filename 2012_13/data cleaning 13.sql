#EXPORT TO CSV FROM RESULTS FOR CLEANER DATA
### update a single row's column

################### DATA CLEANING #############################
#1 "attach elpaty to elcand"  
#use elpaty 9 unless things change
CREATE TABLE cand_13 AS 
SELECT elcand_13.CanNum, elcand_13.CanName, elcand_13.Sex, elcand_13.Age, elcand_13.CurInc, elpaty_9.PParty, elcand_13.RMate
FROM elcand_13
INNER JOIN elpaty_9
ON elcand_13.PPN = elpaty_9.PPN;

SELECT * FROM cand_13;

#join multiple rows into a single column (Pres, Vice Pres Cand in same row)
CREATE TABLE cand_13att AS
SELECT CanNum, PParty,
GROUP_CONCAT(CanName) AS CanNames
FROM cand_13
GROUP BY CanNum;

SELECT * FROM cand_13att;

#DROP TABLE cand_9att;

#2 "attach this cand_11att to elctks before cleaning in R"
CREATE TABLE tks_cand_13 AS
SELECT elctks_13.V1 , elctks_13.V2 , elctks_13.V3 , elctks_13.V4 , elctks_13.V5 , elctks_13.PollN, elctks_13.VotesGot , cand_13att.CanNames, cand_13att.PParty
FROM elctks_13
INNER JOIN cand_13att
ON elctks_13.CanNum = cand_13att.CanNum;

SELECT * FROM tks_cand_13;
# save this as a file tks_cand_13 for use in R, and head back to R for : 
# tidyr spread() on elctks: CanNames + PParty to VotesGot (Candidates x 4 with VotesGot values)
# done in R, on tks_cand_xx 

#grab back tks_cand_xxus

#[7] "宋楚瑜 James Soong,林瑞雄 Lin Ruey-shiung: Peoples.First.Party"
#[8] "馬英九 Ma Ying-jeou,吳敦義 Wu Den-yih: Kuo.Min.Tang"           
#[9] "蔡英文 Tsai Ing-wen,蘇嘉全 Su Jia-chyuan: Dem.Prog.Party"      

## CREATE TABLE TO LOAD tks_cand_xxus, edit column names ##
CREATE TABLE `vote_data`.`tks_cand_13us` (
  `V1` INT(2) NULL,
  `V2` INT(3) NULL,
  `V3` INT(2) NULL,
  `V4` INT(3) NULL,
  `V5` INT(4) NULL,
  `PollN` INT(4) NULL,
  `宋楚瑜 James Soong,林瑞雄 Lin Ruey-shiung: Peoples.First.Party` INT(8) NULL,
  `馬英九 Ma Ying-jeou,吳敦義 Wu Den-yih: Kuo.Min.Tang` INT(8) NULL,
  `蔡英文 Tsai Ing-wen,蘇嘉全 Su Jia-chyuan: Dem.Prog.Party` INT(8) NULL
  )
DEFAULT CHARACTER SET = utf8;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/13/tks_cand_13us.csv' #change
INTO TABLE tks_cand_13us #change
FIELDS TERMINATED BY ','
IGNORE 1 lines; #ignore column names

SELECT * FROM tks_cand_13us;

#4 "clean up elprof as elprof_xxc and attach tks_cand_xxus to it"
CREATE TABLE elprof_13c AS
SELECT elprof_13.V1, elprof_13.V2, elprof_13.V3, elprof_13.V4, elprof_13.V5, elprof_13.PollN, elprof_13.ValidBallot, elprof_13.InvalBallot, 
elprof_13.TotalVote, elprof_13.EligVoter, elprof_13.TotalPop, elprof_13.PerEligVoter, elprof_13.PerActVote	
FROM elprof_13;

SELECT * FROM elprof_13c;

#attaching elprof_xxc and tks_cand_xxus
CREATE TABLE prof_tks_cand_13 AS
SELECT elprof_13c.V1, elprof_13c.V2, elprof_13c.V3, elprof_13c.V4, elprof_13c.V5, elprof_13c.PollN, elprof_13c.ValidBallot, elprof_13c.InvalBallot, 
elprof_13c.TotalVote, elprof_13c.EligVoter, elprof_13c.TotalPop, elprof_13c.PerEligVoter, elprof_13c.PerActVote,
tks_cand_13us.`宋楚瑜 James Soong,林瑞雄 Lin Ruey-shiung: Peoples.First.Party`,
tks_cand_13us.`馬英九 Ma Ying-jeou,吳敦義 Wu Den-yih: Kuo.Min.Tang`,
tks_cand_13us.`蔡英文 Tsai Ing-wen,蘇嘉全 Su Jia-chyuan: Dem.Prog.Party`
FROM elprof_13c
INNER JOIN tks_cand_13us
ON elprof_13c.V1 = tks_cand_13us.V1 AND elprof_13c.V2 = tks_cand_13us.V2 AND elprof_13c.V3 = tks_cand_13us.V3 AND 
elprof_13c.V4 = tks_cand_13us.V4 AND elprof_13c.V5 = tks_cand_13us.V5 AND elprof_13c.PollN = tks_cand_13us.PollN;

SELECT * FROM prof_tks_cand_13;


#5 finally, attach elbase_xxa to prof_tks_cand_xx on V1:V5. selecting both elbase_xxa.AName and elbase_xxa.ANameE
#SELECT * FROM elbase_13a;
CREATE TABLE final_13 AS
SELECT prof_tks_cand_13.PollN, prof_tks_cand_13.ValidBallot, prof_tks_cand_13.InvalBallot, 
prof_tks_cand_13.TotalVote, prof_tks_cand_13.EligVoter, prof_tks_cand_13.TotalPop, prof_tks_cand_13.PerEligVoter, prof_tks_cand_13.PerActVote,
prof_tks_cand_13.`宋楚瑜 James Soong,林瑞雄 Lin Ruey-shiung: Peoples.First.Party`,
prof_tks_cand_13.`馬英九 Ma Ying-jeou,吳敦義 Wu Den-yih: Kuo.Min.Tang`,
prof_tks_cand_13.`蔡英文 Tsai Ing-wen,蘇嘉全 Su Jia-chyuan: Dem.Prog.Party`,
elbase_13A.AName, elbase_13A.ANameE
FROM prof_tks_cand_13
INNER JOIN elbase_13A
ON prof_tks_cand_13.V1 = elbase_13A.V1 AND prof_tks_cand_13.V2 = elbase_13A.V2 AND prof_tks_cand_13.V4 = elbase_13A.V4 AND prof_tks_cand_13.V5 = elbase_13A.V5; #there are values in V3

SELECT * FROM final_13; #save into R

#Finished. head back to R 



















