#############################
# Coursera JHU Data Science #
# Getting & Cleaning Data   #
# Course Project            #
#############################

data.location <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile.name <- "dataset.zip"

## Download data and unzip into current working directory
download.file(data.location, zipfile.name)
unzip(zipfile.name)

## Set appropriate working directory
old.wd <- getwd()
setwd("UCI HAR Dataset")

## Read code rings for activities and features to allow automatic column naming
feature.codering <- read.table('features.txt', col.names=c("id", "label"))
activity.codering <- read.table('activity_labels.txt',
                                col.names=c("id", "activity"))

## Read in subject list.  Note data is merged inline.
subjects <- rbind(read.table('test/subject_test.txt',
                             col.names=c("subject.id")),
                  read.table('train/subject_train.txt',
                             col.names=c("subject.id")))
subjects$subject.id <- factor(subjects$subject.id)

## Read in activity data and create a factor to name the activities.
## Note data is merged inline.
activities <- rbind(read.table('test/y_test.txt',
                               col.names=c("activity")),
                    read.table('train/y_train.txt',
                               col.names=c("activity")))
activities$activity <- factor(activities$activity,
                     levels=activity.codering$id,
                     labels=activity.codering$activity)

## Read in raw features data.  Note that columns are not named at
## this time; names will be created and applied once selecting
## only the relevant columns from the dataset.
rawdata <- rbind(read.table('test/X_test.txt'),
                 read.table('train/X_train.txt'))

## Determine feature columns to select
## Only columns with mean or std deviation data are selected
meanrows <- grep("^[a-zA-Z]+-mean\\(\\)", feature.codering$label)
stdrows <- grep("^[a-zA-Z]+-std\\(\\)", feature.codering$label)
feature.cols <- c(meanrows, stdrows)
feature.names <- feature.codering$label[feature.cols]
feature.names <- as.character(feature.names)

## Make column names pretty
for(j in 1:length(feature.names)) {
    currentName <- feature.names[j]
    currentName <- gsub("-", ".", currentName)
    currentName <- gsub("[\\(\\)]", "", currentName)
    feature.names[j] <- currentName
}

## Filter to relevant columns and apply pretty names to selected
## columns
rawdata.relevant <- rawdata[,feature.cols]
names(rawdata.relevant) <- feature.names

## Join selected data with subjects and activities to form one table
alldata <- cbind(subjects, activities, rawdata.relevant)

## Create tidy data set with average measurements for each subject
## activity combination
library(plyr)
tidydata <- ddply(alldata, .(subject.id, activity), colwise(mean))

## Restore original working directory and export tidy data set
setwd(old.wd)
write.table(tidydata, file="UCI_Tidy.txt")