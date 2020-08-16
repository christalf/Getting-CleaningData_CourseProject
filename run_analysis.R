## Title: Getting and Cleaning Data Course Project | Coursera.
## Autor: christalf.
## Date : August 2020.
## Summary: This script contains the instructions list performed (and that can be
##  reproduced) to:
##  - take the raw data of the course project (a Human Activity Recognition database built
##    from the recordings of 30 subjects performing activities of daily living (ADL) while
##    carrying a waist-mounted smartphone with embedded inertial sensors);
##  - and produce a final tidy dataset contaning the average of each mean and standard
##    deviation measurment for each activity and each subject.

## Download the project's raw data.
datadir <- "."                                  # Working directory.
datasetFile <- "dataset.zip"                    # Name of the file to be downloaded.
datasetPath <- file.path(datadir, datasetFile)  # Complete pathname of the file to be
                                                # downloaded.

dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataUrl, destfile = datasetPath, method = "curl")
dateDownloaded <- date()
zipContent <- unzip(datasetPath, exdir = datadir)

## Read project's raw data from disk.
zipContent

subjectPaths <- list.files(dirname(zipContent[1]),
                           pattern = "^s", full.names = TRUE, recursive = TRUE)
subjectList <- lapply(subjectPaths, read.table)

xPaths <- list.files(dirname(zipContent[1]),
                     pattern = "^X", full.names = TRUE, recursive = TRUE)
xList <- lapply(xPaths, read.table)

yPaths <- list.files(dirname(zipContent[1]),
                     pattern = "^y", full.names = TRUE, recursive = TRUE)
yList <- lapply(yPaths, read.table)

activities <- read.table(zipContent[1], col.names = c("label", "activity"))

features <- read.table(zipContent[2], col.names = c("code", "feature"))

## Merge the training and the test sets to create one dataset.
subjectMerged <- do.call(rbind, subjectList)
colnames(subjectMerged) <- "subject"

xMerged <- do.call(rbind, xList)
colnames(xMerged) <- features$feature

yMerged <- do.call(rbind, yList)
colnames(yMerged) <- "label"

mergedDataset <- cbind(subjectMerged, xMerged, yMerged)
str(mergedDataset)

## Extract only the measurments on the mean and standard deviation for each
## measurement.
library(dplyr)

means_stds <- grep("[Mm]ean|std", features$feature, value = TRUE)

meanStdDataset <- mergedDataset %>%
                  select(subject, label, all_of(means_stds)) %>%
                  arrange(subject, label)

## Use descriptive activity names to name the activities in the dataset.
meanStdDataset$label <- activities[meanStdDataset$label, "activity"]

## Appropriately label the dataset with descriptive variable names.
pattern <- c("label", "^t", "^f", "-", ",|\\(,", "Acc", "Gyro", "Mag", "jerk",
             "mean\\(\\)", "std\\(\\)", "meanFreq\\(\\)", "^angle\\(t",
             "^angle\\(X", "^angle\\(Y", "^angle\\(Z", "gravity\\)",
             "gravityMean\\)", "BodyBody")
replacement <- c("activity", "time", "frequency", "", ".", "Accelerometer",
                 "Gyroscope", "Magnitude", "Jerk", ".mean", ".standard",
                 ".meanFrequency", "angle.Time", "angle.X", "angle.Y",
                 "angle.Z", "Gravity", "GravityMean", "Body")

for(i in seq_along(pattern)) {
        colnames(meanStdDataset) <- gsub(pattern[i], replacement[i],
                                         colnames(meanStdDataset))
}

## From the dataset in the previous step, create a second, independent tidy
## dataset with the average of each variable for each activity and each subject.
averagesDataset <- meanStdDataset %>%
                   group_by(activity, subject) %>%
                   summarize(across(where(is.numeric), mean))
averagesDataset
str(averagesDataset)

## Export final tidy dataset.
write.table(averagesDataset, file = file.path(datadir, "tidyFinalData.txt"),
            row.names = FALSE)

