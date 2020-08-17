## This script will do the following:

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

####################################
##Install appropriate library 
install.packages("dplyr")
library(dplyr)

## Clearing the workspace

rm=(list=ls())

##Downloading file, putting it in the RData folder and extracting it

if(!file.exists("./RData")){dir.create("./RData")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./RData/Dataset.zip",method="curl")
unzip(zipfile="./RData/Dataset.zip",exdir="./RData")

#Retrieve the list of files
path <- file.path("./RData" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)
files

##We only want data from specific files. We will read them into variables

activityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
activityTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)

subjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
subjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)

featuresTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
featuresTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

## 1. MERGE TRAINING AND TEST DATA TO CREATE ONE DATASET

activityData <- rbind(activityTest, activityTrain)
subjectData <- rbind(subjectTest, subjectTrain)
featuresData <- rbind(featuresTest, featuresTrain)

names(activityData) <- c("activity")
names(subjectData) <- c("subject")
featureNames <- read.table(file.path(path, "features.txt"), head=FALSE)
names(featuresData) <- featureNames$V2

combinedData <- cbind(activityData, subjectData)

fullData <- cbind(featuresData, combinedData)

## 2. EXTRACT MEASUREMENTS FOR MEAN AND STD DEVIATION FOR EACH MEASUREMENTS

subjectDataMean <- sapply(subjectData, mean, na.rm=TRUE)  
subjectDataStdDev<  - sapply(subjectData, sd, na.rm=TRUE) 
activityDataMean <- sapply(activityData, mean, na.rm=TRUE)  
activityDataStdDev <- sapply(activityData, sd, na.rm=TRUE)  
featuresDataMean <- sapply(featuresData, mean, na.rm=TRUE)  
featuresDataStdDev <-sapply(featuresData, sd, na.rm=TRUE) 

## 3. USE DESCRIPTIVE NAMES FOR ACTIVITIES IN DATA SET

activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)

fullData$activity[fullData$activity==1] <- "WALKING"
fullData$activity[fullData$activity==2] <- "WALKING_UPSTAIRS"
fullData$activity[fullData$activity==3] <- "WALKING_DOWNSTAIRS"
fullData$activity[fullData$activity==4] <- "SITTING"
fullData$activity[fullData$activity==5] <- "STANDING"
fullData$activity[fullData$activity==6] <- "LAYING"

## printing out the dataset to see if changing the names worked
head(fullData$activity,30)

## 4. APPROPRIATELY LABELS DATASET WITH DESCRIPTIVE NAMES

names(fullData)<-gsub("^t", "Time", names(fullData))
names(fullData)<-gsub("^f", "Frequency", names(fullData))
names(fullData)<-gsub("Acc", "Accelerometer", names(fullData))
names(fullData)<-gsub("Gyro", "Gyroscope", names(fullData))
names(fullData)<-gsub("Mag", "Magnitude", names(fullData))
names(fullData)<-gsub("BodyBody", "Body", names(fullData))

## printing out the dataset to see if changing the names worked
head(fullData)

## 4. Create 2nd, independent data set and output it

##Install appropriate library 
install.packages("plyr")
library(plyr)

fullData2 <- aggregate(. ~subject + activity, fullData, mean)
fullData2 <- fullData2[order(fullData2$subject,fullData2$activity),]
write.table(fullData2, file = "fullData2.txt",row.name=FALSE)
fullData2


