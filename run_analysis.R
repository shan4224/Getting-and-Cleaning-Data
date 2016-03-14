
setwd("E:\\SS\\Coursera Data Science Specialization\\Getting and Cleaning Data\\Week 4\\Assignment")

# Create Directory
if(!file.exists("data1")){
  dir.create("./data1")
}

# Download File
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"./data1/Dataset.zip",method="auto")


# Unzip the file

unzip(zipfile="./data1/Dataset.zip",exdir="./data1")

#unzipped files are in the folderUCI HAR Dataset. Get the list of the files

path_rf <- file.path("./data1" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files


#we can see:
#Values of Varible Activity consist of data from "Y_train.txt" and "Y_test.txt"
#values of Varible Subject consist of data from "subject_train.txt" and subject_test.txt"
#Values of Varibles Features consist of data from "X_train.txt" and "X_test.txt"
#Names of Varibles Features come from "features.txt"
#levels of Varible Activity come from "activity_labels.txt"
#So we will use Activity, Subject and Features as part of descriptive variable names for data in data frame.

#Read data from the files into the variables

#Read the Activity files

dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)


#Read the Subject files
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

#Read Fearures files
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

# Structure of the above varibles
str(dataActivityTest)
## 'data.frame':    2947 obs. of  1 variable:
##  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
str(dataActivityTrain)
## 'data.frame':    7352 obs. of  1 variable:
##  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
str(dataSubjectTrain)
## 'data.frame':    7352 obs. of  1 variable:
##  $ V1: int  1 1 1 1 1 1 1 1 1 1 ...
str(dataSubjectTest)
## 'data.frame':    2947 obs. of  1 variable:
##  $ V1: int  2 2 2 2 2 2 2 2 2 2 ...
str(dataFeaturesTest)


# 1.Merge the training and the test sets to create one data set
# Append the data tables by rows

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

#set names to variables

names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

#Merge columns to get the data frame Data for all data

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#2.Extracts only the measurements on the mean and standard deviation for each measurement
#Subset Name of Features by measurements on the mean and standard deviation
#i.e taken Names of Features with "mean()" or "std()"

subdataFeaturesNames <- dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

#Subset the data frame Data by seleted names of Features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#structures of the data frame Data
str(Data)

# 3. Uses descriptive activity names to name the activities in the data set
# Read descriptive activity names from "activity_labels.txt"

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

#facorize Variable activity in the data frame Data using descriptive activity names

head(Data$activity,50)


# 4. Appropriately labels the data set with descriptive variable names.
#In the former part, variables activity and subject and names of the activities have been labelled using 
#descriptive names.In this part, Names of Features will labelled using descriptive variable names.

#prefix t is replaced by time
#Acc is replaced by Accelerometer
#Gyro is replaced by Gyroscope
#prefix f is replaced by frequency
#Mag is replaced by Magnitude
#BodyBody is replaced by Body


names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))


names(Data)

# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#Creates a second,independent tidy data set and ouput it
#In this part,a second, independent tidy data set will be created with the average of each variable 
#for each activity and each subject based on the data set in step 4.

library(plyr)
Data1<-aggregate(. ~subject + activity, Data, mean)
Data1<-Data1[order(Data1$subject,Data1$activity),]
write.table(Data1, file = "tidydata.txt",row.names=FALSE)
write.table(Data1, file = "tidydata.csv",row.names=FALSE)

#Produce Codebook
library(knitr)
knit2html("codebook.Rmd")






























































































































































































































