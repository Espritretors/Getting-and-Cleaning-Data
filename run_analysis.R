#Getting and Cleaning Data

library(data.table)
library(reshape2)
library(dplyr)
library(tidyr)

# File download. If file does not exist, download to working directory.
if(!file.exists("UCIdata.zip"))
  {download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","UCIdata.zip", mode = "wb")}

# File unzip. If file does not exist n the directory, unzip.
if(!file.exists("UCI HAR Dataset"))
  {unzip("UCIdata.zip", files = NULL, exdir=".")}

# Get the activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
# Get the features (column names)
features <- read.table("UCI HAR Dataset/features.txt")
# Get the test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
# Get the training data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

# Set the column names
colnames(X_test) <- features[,2] 
colnames(y_test) <- "ActivityId"
colnames(subject_test) <- "SubjectId"
colnames(X_train) <- features[,2] 
colnames(y_train) <-"ActivityId"
colnames(subject_train) <- "SubjectId"
colnames(activity_labels) <- c('ActivityId','ActivityType')

# Keep only the mean and std of the data sets
X_train = X_train[,grep("mean()|std()", features[, 2])]
X_test = X_test[,grep("mean()|std()", features[, 2])]

# Merge the data sets
mergetrain <- cbind(subject_train, y_train, X_train)
mergetest <- cbind(subject_test,y_test, X_test)
mergeall <- rbind(mergetrain, mergetest)

# Replace the activity number with the activity description
merge_actlabels <- merge(activity_labels, mergeall, by="ActivityId")
merge_actlabels <- subset(merge_actlabels, select = -c(ActivityId))

#Creates a second, independent tidy data set with the average of each variable for each activity 
#and each subject
melteddata <- melt(merge_actlabels,(id.vars=c("SubjectId","ActivityType")))
finaldata <- dcast(melteddata, SubjectId + ActivityType ~ variable, mean, na.rm = TRUE)

#Rename variables with more lisible variable names
names(finaldata) <- gsub("\\(|\\)", "", names(finaldata))
names(finaldata)<-gsub("mean()", "MEAN", names(finaldata))
names(finaldata)<-gsub("std()", "STD", names(finaldata))
names(finaldata)<-gsub("Acc", "Accelerometer", names(finaldata))
names(finaldata)<-gsub("Gyro", "Gyroscope", names(finaldata))
names(finaldata)<-gsub("Mag", "Magnitude", names(finaldata))
names(finaldata)<-gsub("BodyBody", "Body", names(finaldata))
names(finaldata)<-gsub("^t", "time", names(finaldata))
names(finaldata)<-gsub("^f", "frequency", names(finaldata))

#Writes the tidy data set in txt file
write.table(finaldata, file = "./tidy_data.txt", row.name=FALSE)