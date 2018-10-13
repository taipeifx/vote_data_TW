cat('\014') #clears console
rm(list = ls()) #removes global environment
library(dplyr)
library(readr)

#Start with new templates in mysql workbench
a9 = read_csv("final_9.csv",col_names = T)
a10 = read_csv("final_10.csv",col_names = T)
a11 = read_csv("final_11.csv",col_names = T)
a12 = read_csv("final_12.csv",col_names = T)
a13 = read_csv("final_13.csv",col_names = T)
a14 = read_csv("final_14.csv",col_names = T)


######################### grab major areas from each year for analysis #######################

#########################999999999999999999999999999999999#######################
View(a9)

##check if total votes match up:
a9$TotalVote[1] #[1] 10883279
sum(a9$TotalVote[c(2:26)]) #10883279

#Change Wuhu County to Penghu County
a9$ANameE[19] = "Penghu County"
write_csv(a9, "final_9.csv")

################## The following areas make up the entire taiwan vote
a9$AName[c(2:26)]
#[1] "�O�_��" "������" "�O�_��" "�y����" "��鿤" "�s�˿�" "�]�߿�" "�O����"
#[9] "���ƿ�" "�n�뿤" "���L��" "�Ÿq��" "�O�n��" "������" "�̪F��" "�O�F��"
#[17] "�Ὤ��" "���" "�򶩥�" "�s�˥�" "�O����" "�Ÿq��" "�O�n��" "������"
#[25] "�s����"

a9$ANameE[c(2:26)]
#[1] "Taipei City "      "Kaohsiung City "   "Taipei County "    "Yilan County "    
#[5] "Taoyuan County "   "Hsinchu County "   "Miaoli County "    "Taichung County " 
#[9] "Changhua County "  "Nantou County "    "Yunlin County "    "Chiayi County "   
#[13] "Tainan County "    "Kaohsiung County " "Pingtung County "  "Taitung County "  
#[17] "Hualien County "   "Penghu County"       "Keelung City "     "Hsinchu City "    
#[21] "Taichung City "    "Chiayi City "      "Tainan City "      "Jinmen County "   
#[25] "Lianjiang County "

#Taichung County 
#Tainan County 
#Kaohsiung County 

a9[a9$AName == "�s����",]

a9[c(2:26),]
write_csv(a9[c(1:26),], "finalgrab_9.csv")
read_csv("finalgrab_9.csv",col_names = T)

write_csv(g9, "finalgrab_9.csv")
#########################999999999999999999999999999999999#######################

#########################101010101010101010101010101010101#######################
View(a10)

##check if total votes match up:
a10$TotalVote[1] #[1] 12786671
sum(a10$TotalVote[c(2:26)]) #12786671

#Change Wuhu County to Penghu County
a10$ANameE[19] = "Penghu County"
write_csv(a10, "final_10.csv")

################## The following areas make up the entire taiwan vote
a10$AName[c(2:26)]
#[1] "�O�_��" "������" "�O�_��" "�y����" "��鿤" "�s�˿�" "�]�߿�" "�O����"
#[9] "���ƿ�" "�n�뿤" "���L��" "�Ÿq��" "�O�n��" "������" "�̪F��" "�O�F��"
#[17] "�Ὤ��" "���" "�򶩥�" "�s�˥�" "�O����" "�Ÿq��" "�O�n��" "������"
#[25] "�s����"

a10$ANameE[c(2:26)]
#[1] "Taipei City"      "Kaohsiung City"   "Taipei County"    "Yilan County"    
#[5] "Taoyuan County"   "Hsinchu County"   "Miaoli County"    "Taichung County" 
#[9] "Changhua County"  "Nantou County"    "Yunlin County"    "Chiayi County"   
#[13] "Tainan County"    "Kaohsiung County" "Pingtung County"  "Taitung County"  
#[17] "Hualien County"   "Penghu County"      "Keelung City"     "Hsinchu City"    
#[21] "Taichung City"    "Chiayi City"      "Tainan City"      "Jinmen County"   
#[25] "Lianjiang County"
a9[a9$AName == "�s����",]

a10[c(2:26),]
write_csv(a10[c(1:26),], "finalgrab_10.csv")

write_csv(g10, "finalgrab_10.csv")
#########################101010101010101010101010101010101#######################

#########################111111111111111111111111111111111#######################
View(a11)

##check if total votes match up:
a11$TotalVote[1] #[1] 13251719
sum(a11$TotalVote[c(2:26)]) #13251719

#Change Wuhu County to Penghu County
a11$ANameE[19] = "Penghu County"
write_csv(a11, "final_11.csv")

################## The following areas make up the entire taiwan vote
a11$AName[c(2:26)]
#[1] "�O�_��" "������" "�O�_��" "�y����" "��鿤" "�s�˿�" "�]�߿�" "�O����"
#[9] "���ƿ�" "�n�뿤" "���L��" "�Ÿq��" "�O�n��" "������" "�̪F��" "�O�F��"
#[17] "�Ὤ��" "���" "�򶩥�" "�s�˥�" "�O����" "�Ÿq��" "�O�n��" "������"
#[25] "�s����"

a11$ANameE[c(2:26)]
#[1] "Taipei City"      "Kaohsiung City"   "Taipei County"    "Yilan County"    
#[5] "Taoyuan County"   "Hsinchu County"   "Miaoli County"    "Taichung County" 
#[9] "Changhua County"  "Nantou County"    "Yunlin County"    "Chiayi County"   
#[13] "Tainan County"    "Kaohsiung County" "Pingtung County"  "Taitung County"  
#[17] "Hualien County"   "Penghu County"      "Keelung City"     "Hsinchu City"    
#[21] "Taichung City"    "Chiayi City"      "Tainan City"      "Jinmen County"   
#[25] "Lianjiang County"
a11[a11$AName == "�s����",]

a11[c(2:26),]
write_csv(a11[c(1:26),], "finalgrab_11.csv")
#########################111111111111111111111111111111111#######################

#########################12121212121212121212121212121212########################
View(a12)

##check if total votes match up:
a12$TotalVote[1] #[1] 13221609
sum(a12$TotalVote[c(2:13, 15:18,20,22,23,31,35,50,111,132, 625)]) #13221609

#Change Wuhu County to Penghu County
a12$ANameE[111] = "Penghu County"
write_csv(a12, "final_12.csv")

################## The following areas make up the entire taiwan vote
a12$AName[c(2:13, 15:18,20,22,23,31,35,50,111,132, 625)]
#[1] "�O�_��" "�O�_��" "��鿤" "������" "�O����" "���ƿ�" "������" "�O�n��" "�O����" "�̪F��"
#[11] "�O�n��" "���L��" "�]�߿�" "�Ÿq��" "�n�뿤" "�s�˿�" "�y����" "�s�˥�" "�򶩥�" "�Ὤ��"
#[21] "�Ÿq��" "�O�F��" "���" "������" "�s����"


a12$ANameE[c(2:13, 15:18,20,22,23,31,35,50,111,132, 625)]
#[1] "Taipei County"    "Taipei City"      "Taoyuan County"   "Kaohsiung City"   "Taichung County" 
#[6] "Changhua County"  "Kaohsiung County" "Tainan County"    "Taichung City"    "Pingtung County" 
#[11] "Tainan City"      "Yunlin County"    "Miaoli County"    "Chiayi County"    "Nantou County"   
#[16] "Hsinchu County"   "Yilan County"     "Hsinchu City"     "Keelung City"     "Hualien County"  
#[21] "Chiayi City"      "Taitung County"   "Wuhu County"      "Jinmen County"    "Lianjiang County"

a12[a12$AName == "�s����",]

a12[c(2:13, 15:18,20,22,23,31,35,50,111,132, 625),]
write_csv(a12[c(1:13, 15:18,20,22,23,31,35,50,111,132, 625),], "finalgrab_12.csv")
#########################12121212121212121212121212121212212#######################


#from 13, no more #Taichung County #Tainan County #Kaohsiung County 
#########################13131313131313131313131313131313131313#######################
View(a13)

##check if total votes match up:
##check if total votes match up:
a13$TotalVote[1] #[1] 13452016
sum(a13$TotalVote[c(2:9, 10, 12:15,17,19,22, 29,33,51,106,124,478)]) #13452016


################## The following areas make up the entire taiwan vote
a13$AName[c(2:9, 10, 12:15,17,19,22, 29,33,51,106,124,478)]
#[1] "�s�_��" "������" "�O�_��" "�O����" "��鿤" "�O�n��" "���ƿ�" "�̪F��" "���L��" "�]�߿�" "�Ÿq��"
#[12] "�n�뿤" "�s�˿�" "�y����" "�s�˥�" "�򶩥�" "�Ὤ��" "�Ÿq��" "�O�F��" "���" "������" "�s����"

a13$ANameE[c(2:9, 10, 12:15,17,19,22, 29,33,51,106,124,478)]
#[1] "New Taipei City"  "Kaohsiung City"   "Taipei City"      "Taichung City"    "Taoyuan County"  
#[6] "Tainan City"      "Changhua County"  "Pingtung County"  "Yunlin County"    "Miaoli County"   
#[11] "Chiayi County"    "Nantou County"    "Hsinchu County"   "Yilan County"     "Hsinchu City"    
#[16] "Keelung City"     "Hualien County"   "Chiayi City"      "Taitung County"   "Penghu County"   
#[21] "Jinmen County"    "Lianjiang County"

#Change Wuhu County to Penghu County
a13$ANameE[106] = "Penghu County"
write_csv(a13, "final_13.csv")

a13[c(2:9, 10, 12:15,17,19,22, 29,33,51,106,124,478),]
write_csv(a13[c(1:9, 10, 12:15,17,19,22, 29,33,51,106,124,478),], "finalgrab_13.csv")
#########################13131313131313131313131313131313131313#######################


#########################1414141414141414141414141414141414141414#######################
View(a14)

##check if total votes match up:
##check if total votes match up:
a14$TotalVote[1] #[1] 12448302
sum(a14$TotalVote[c(2:10, 12:16,18,23, 29,33,54,106, 123,564)]) #12448302


################## The following areas make up the entire taiwan vote
a14$AName[c(2:10, 12:16,18,23, 29,33,54,106, 123,564)]
#[1] "�s�_��" "������" "�O�_��" "�O����" "��鿤" "�O�n��" "���ƿ�" "�̪F��" "���L��" "�]�߿�" "�Ÿq��"
#[12] "�n�뿤" "�s�˿�" "�y����" "�s�˥�" "�򶩥�" "�Ὤ��" "�Ÿq��" "�O�F��" "���" "������" "�s����"

a14$ANameE[c(2:10, 12:16,18,23, 29,33,54,106, 123,564)]
#[1] "New Taipei City"  "Kaohsiung City"   "Taipei City"      "Taichung City"    "Taoyuan County"  
#[6] "Tainan City"      "Changhua County"  "Pingtung County"  "Yunlin County"    "Miaoli County"   
#[11] "Chiayi County"    "Nantou County"    "Hsinchu County"   "Yilan County"     "Hsinchu City"    
#[16] "Keelung City"     "Hualien County"   "Chiayi City"      "Taitung County"   "Penghu County"   
#[21] "Jinmen County"    "Lianjiang County"

#Change Wuhu County to Penghu County
a14$ANameE[106] = "Penghu County"
write_csv(a14, "final_14.csv")

a14[c(2:10, 12:16,18,23, 29,33,54,106, 123,564),]
write_csv(a14[c(1:10, 12:16,18,23, 29,33,54,106, 123,564),], "finalgrab_14.csv")
#########################1414141414141414141414141414141414141414#######################

###################################################################################
## should have axx by now:
axx = read_csv("axx.csv")
View(axx)

#let's reorder it
#axx = axx[order(axx$TotalVote, decreasing = T),]
#write_csv(x = axx, "axx.csv") #resave it

#sum(axx[1,c(9:10)]) #check if sum of votes = ValidBallot

##check if total votes match up:
axx$TotalVote[1] #[1] 12448302
sum(axx$TotalVote[c(2:10, 12:16,18,23, 29,33,54,106, 123,564)]) #12448302


################## The following areas make up the entire taiwan vote
#[1] "�s�_��" "������" "�O�_��" "�O����" "��鿤" "�O�n��" "���ƿ�" "�̪F��" "���L��" "�]�߿�" "�Ÿq��"
#[12] "�n�뿤" "�s�˿�" "�y����" "�s�˥�" "�򶩥�" "�Ὤ��" "�Ÿq��" "�O�F��" "���" "������" "�s����"
axx$AName[c(2:10, 12:16,18,23, 29,33,54,106, 123,564)]

axx[axx$AName == "�s����",]


g9 = read_csv("finalgrab_9.csv",col_names = T)
g10 = read_csv("finalgrab_10.csv",col_names = T)
g11 = read_csv("finalgrab_11.csv",col_names = T)
g12 = read_csv("finalgrab_12.csv",col_names = T)
g13 = read_csv("finalgrab_13.csv",col_names = T)
g14 = read_csv("finalgrab_14.csv",col_names = T)

g9$ANameE[1]
2678/3895
g9$PerEligVoter = round(g9$EligVoter/g9$TotalPop*100, digits = 2)
#

g10$PerEligVoter = round(g10$EligVoter/g10$TotalPop*100, digits = 2)

g14 = g14[-1]
write_csv(g14, "finalgrab_14.csv")















