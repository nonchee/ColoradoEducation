#Load the data
Change_2010 <- read.csv(file="./Data/2010_1YR_3YR_change.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
Coact_2010 <- read.csv(file="./Data/2010_COACT.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
DataMap_2010 <- read.csv(file="./Data/2010_data_map.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
Enrlworking_2010 <- read.csv(file="./Data/2010_enrl_working.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
FinalGrade_2010 <- read.csv(file="./Data/2010_final_grade.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
FRL_2010 <- read.csv(file="./Data/2010_k_12_FRL.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
Remediation_2010 <- read.csv(file="./Data/2010_remediation_HS.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
Address_2010 <- read.csv(file="./Data/2010_school_address.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)

# Change_2010 : 1 & 3 year changes in academic acheivement, growth, overall grade.
# Coact_2010 : Ready for college or not based on ACT (Yes=1,No=2)
# DataMap_2010 : 
# Enrlworking_2010 : Percentage of each ethnicity/race characteristics
# FinalGrade_2010 : Grades given for each school
# FRL_2010 : Percentage of students getting free/reduced price lunch
# Remediation_2010 : Percentage of students requiring remediation
# Address_2010 : Physical address of the schools


#------------------Combine all the data for this year----------------------------#
#Order : FinalGrade - Change - Coact - Enrlworking - FRL- remediation

#1. Combine FinalGrade and Change -> total
Change_2010_new <- Change_2010[,-which(names(Change_2010) %in% 
                                        c("School.Name","District.Number","District.Name","EMH_combined"))]
Total_2010 <- merge(FinalGrade_2010,Change_2010_new,
                    by.x=c("SchoolNumber","EMH"),by.y=c("School.Number","EMH"),
                    all.x = TRUE)

#2. Combine total and Coact
h = dim(Coact_2010)[1]
EMH = rep("H",h)
Coact_2010_new <- cbind(Coact_2010,EMH)
Coact_2010_new <- Coact_2010_new[,-which(names(Coact_2010_new) %in% 
                                        c("District.No","X2010.School.Name"))]
Total_2010 <- merge(Total_2010,Coact_2010_new,
                    by.x=c("SchoolNumber","EMH"),by.y=c("School.No","EMH"),
                    all.x = TRUE)

#3. Combine total and EnrlWorking
Enrlworking_2010_new <- Enrlworking_2010[,-which(names(Enrlworking_2010) %in%
                                             c("Org..Code","Organization.Name","School.Name"))]
Total_2010 <- merge(Total_2010,Enrlworking_2010_new,
                    by.x="SchoolNumber",by.y="School.Code",
                    all.x = TRUE)

#4. Combine total and FRL
FRL_2010_new = FRL_2010[,-which(names(FRL_2010) %in% 
                                   c("DISTRICT.CODE","DISTRICT.NAME","SCHOOL.NAME"))]
Total_2010 <- merge(Total_2010,FRL_2010_new,
                    by.x="SchoolNumber",by.y="SCHOOL.CODE",
                    all.x = TRUE)

#5. Combine Remediation
h = dim(Remediation_2010)[1]
EMH = rep("H",h)
Remediation_2010_new <- cbind(Remediation_2010,EMH)
Remediation_2010_new <- Remediation_2010_new[,-which(names(Remediation_2010_new) %in%
                                                        c("School_District","SchoolName"))]
Total_2010 <- merge(Total_2010,Remediation_2010_new,
                    by.x=c("SchoolNumber","EMH"),by.y=c("SchoolNumber","EMH"),
                    all.x = TRUE)
Total_2010_Names <- colnames(Total_2010)

write.table(Total_2010_Names,file="Total_2010_Names.csv", row.names=FALSE,col.names=FALSE,sep=",")
write.table(Total_2010,file="Total_2010.csv", row.names=FALSE,col.names=FALSE,sep=",")

#-------------Clean the data-------------------#
#Get rid of unnecessary data
Data_2010 <- Total_2010[,-(8:15)]
changeName <- read.csv(file="./Raw_Data_Names.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)

#Clean up the column names
require(plyr)
colnames(Data_2010) <- mapvalues(colnames(Data_2010), from = changeName[,1],to=changeName[,2])

#Make the decimal values into percentage values
Data_2010[,28:34] <- Data_2010[,28:34]  * 100 
Data_2010[,35] <- as.numeric(sub("%", "", Data_2010[,35]),na.rm = TRUE)

Data_2010_Names <- colnames(Data_2010)
Data_2010_Type = sapply(Data_2010, class) 

write.table(Data_2010_Names,file="Data_2010_Names.csv", row.names=FALSE,col.names=FALSE,sep=",")
write.table(Data_2010,file="Data_2010.csv", row.names=FALSE,col.names=FALSE,sep=",")
write.table(Data_2010_Type,file="Data_2010_Type.csv", row.names=FALSE,col.names=FALSE,sep=",")