## This script will do the following:

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

####################################
##Install appropriate library
#install.packages("dplyr")
library(dplyr)

## Clearing the workspace

rm=(list=ls())

##We only want data from specific files. We will read them into variables

library(dplyr)
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("/Users/angelamutua/Desktop/R/GettingAndCleaningData/UCI HAR Dataset/test/y_test.txt", col.names = "code")

subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## 1. MERGE TRAINING AND TEST DATA TO CREATE ONE DATASET

mergex <- rbind(x_train, x_test)
mergey <- rbind(y_train, y_test)
mergesubject <- rbind(subjectTrain, subjectTest)
fullData <- cbind(mergesubject, mergex, mergey)

## 2. EXTRACT MEASUREMENTS FOR MEAN AND STD DEVIATION FOR EACH MEASUREMENTS

tidyData <- fullData %>% select(subject, code, contains("mean"), contains("std"))

## 3. USE DESCRIPTIVE NAMES FOR ACTIVITIES IN DATA SET
## 4. APPROPRIATELY LABELS DATASET WITH DESCRIPTIVE NAMES

tidyData$code <- activityLabels[tidyData$code, 2]
names(tidyData)[2] = "activity"
names(tidyData)<-gsub("Acc", "Accelerometer", names(tidyData))
names(tidyData)<-gsub("Gyro", "Gyroscope", names(tidyData))
names(tidyData)<-gsub("BodyBody", "Body", names(tidyData))
names(tidyData)<-gsub("Mag", "Magnitude", names(tidyData))
names(tidyData)<-gsub("^t", "Time", names(tidyData))
names(tidyData)<-gsub("^f", "Frequency", names(tidyData))
names(tidyData)<-gsub("tBody", "TimeBody", names(tidyData))
names(tidyData)<-gsub("-mean()", "Mean", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-std()", "STD", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-freq()", "Frequency", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("angle", "Angle", names(tidyData))
names(tidyData)<-gsub("gravity", "Gravity", names(tidyData))

## 5. Create 2nd, independent data set and output it

finalData <- tidyData %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(finalData, file = "finalData.txt",row.name=FALSE)


