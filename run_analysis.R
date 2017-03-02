

#set directory, download and unzip file
setwd("D:/COURSERA/gcdata")
library(dplyr)
library(data.table)


if(!file.exists("./data")){dir.create("./data")}
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL,destfile="./data/Dataset.zip")

unzip(zipfile="./data/Dataset.zip",exdir="./data")


#Read the test and train files
test_labels <- read.table( "./data/UCI HAR Dataset/test/y_test.txt", col.names="label")
test_subjects <- read.table( "./data/UCI HAR Dataset/test/subject_test.txt",col.names="subject")
test_data <- read.table( "./data/UCI HAR Dataset/test/X_test.txt")

train_labels <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names="label")
train_subjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names="subject")
train_data <- read.table( "./data/UCI HAR Dataset/train/X_train.txt")


#1.Create one data set for train data and another one for test data then merge the two into one single data set.                    
merge_train <- cbind(train_labels, train_subjects, train_data)
merge_test <- cbind(test_labels, test_subjects, test_data)

merge_train_test <- rbind(merge_train, merge_test)

                           
# 2. Extracts only the measurements on the mean and standard deviation for each measurement:

features <- read.table("data/UCI HAR Dataset/features.txt")[,2]
colnames(merge_train_test) <- c("activity", "subject", colnames(features))
extract_features <- grepl("mean|std", features)
mean_std <- merge_train_test[,extract_features==TRUE]


#3.Uses descriptive activity names to name the activities in the data set

activity_labels = read.table( "data/UCI HAR Dataset/activity_labels.txt")
mean_std$activity <- activity_labels[mean_std$activity,2]


#4.Appropriately labels the data set with descriptive variable names.

features_mean_std <- features[extract_features==TRUE]
colnames(mean_std) <- c("activity", "subject", features_mean_std)


#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidyset <- aggregate(. ~subject + activity, mean_std, mean)
write.table(tidyset, "tidyset.txt", row.name=FALSE)
