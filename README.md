# getting-and-cleaning-data-coursera

## Repo Files

1. R/r_analysis -> path to R script
2. README.md (this file) -> file describing the contect of the repo
3. CodeBook.md -> file describing data and variables

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 

The dataset was found at:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
You should create one R script called run_analysis.R that does the following:

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive activity names.
Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

1. Read all the relevant data from the folder to variables
2. Combine all the data into one data set
3. Using the dplyr package, use sapply to extract the standard deviation and means of the specified data
4. Read the activity labels from activity.txt and set the descriptive names to the data set
5. Label the measurements in the dataset with descriptive names
6. Create a 2nd dataset that aggreates all the data by finding the average of the subject and activty data
7. Output the dataset
