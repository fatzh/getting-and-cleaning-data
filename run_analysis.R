##
## run_analysis.R
##
## This script assumes the data to be located in the "data" folder.
##
## 1. merge the training and the test sets to create one data set
## 2. Extracts only the measurements on the mean and standard deviation 
## for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set
## with the average of each variable for each activity and each subject.

## preparation

## test if the data set is in the working directory
if(!file.exists('./UCI HAR Dataset/')) {
    stop("Data set 'UCI HAR Dataset' is not in the working directory.")
}
##
## load libraries
library(dplyr)

##
# use to reload everything...
reload <- TRUE
### ---------------------------------------------------------------
### 1. Merges the training and the test sets to create one data set
### ---------------------------------------------------------------

## training data : create one dataset with subjects, activities and measures
if(reload) {
    d1 <- read.table('./UCI HAR Dataset/train/subject_train.txt', sep = "", col.names = "Subject")
    d2 <- read.table('./UCI HAR Dataset/train/y_train.txt', sep = "", col.names = "Activity")
    d3 <- read.table('./UCI HAR Dataset/train/X_train.txt', sep = "")
    d_training <- cbind(d1, d2, d3)
}

## test data : create one dataset with subjects, activities and measures
if(reload) {
    d1 <- read.table('./UCI HAR Dataset/test/subject_test.txt', sep = "", col.names = "Subject")
    d2 <- read.table('./UCI HAR Dataset/test/y_test.txt', sep = "", col.names = "Activity")
    d3 <- read.table('./UCI HAR Dataset/test/X_test.txt', sep = "")
    d_test <- cbind(d1, d2, d3)
}

## and merge both datasets
d_merged <- rbind(d_training, d_test)

### -----------------------------------------------------------------------------------------
### 2. Extracts only the measurements on the mean and standard deviation for each measurement
### -----------------------------------------------------------------------------------------

## Add labels to columns
features <- read.table('./UCI HAR Dataset/features.txt', sep = "", stringsAsFactors = FALSE, col.names = c("col_num", "name"))

# Create a logical vector with the columns we want to keep
# (i.e. the columns containing the mean or the standard deviation of a measurement)
features_to_keep <- grepl("mean\\(\\)|std\\(\\)", features$name)

# in the merged dataset, the first column contains the subjects, and the second column contains the activities
# so we keep this 2 cols as well
cols_to_keep <- c(TRUE, TRUE, features_to_keep)

# select only the columns to keep
d <- select(d_merged, which(cols_to_keep))

### -------------------------------------------------------------------------
### 3. Uses descriptive activity names to name the activities in the data set
### -------------------------------------------------------------------------
activities <- read.table('./UCI HAR Dataset/activity_labels.txt', sep = "")
d <- mutate(d, Activity = activities[Activity, 2])

### ---------------------------------------------------------------------
### 4. Appropriately labels the data set with descriptive variable names. 
### ---------------------------------------------------------------------

# get the feature names
features_names <- features[which(features_to_keep),]$name

# use regex to tidy the feature names
features_names <- gsub("Jerk", ".Jerk.", features_names)
features_names <- gsub("Mag", ".Magnitude.", features_names)
features_names <- gsub("BodyAcc|BodyBodyAcc", "Body Acceleration", features_names)
features_names <- gsub("GravityAcc", "Gravity Acceleration", features_names)
features_names <- gsub("BodyGyro|BodyBodyGyro", "Body Angular Velocity", features_names)
features_names <- gsub("\\-mean\\(\\)", ".Mean", features_names)
features_names <- gsub("\\-std\\(\\)", ".Standard Deviation", features_names)
features_names <- gsub("\\-X", ".X axis", features_names)
features_names <- gsub("\\-Y", ".Y axis", features_names)
features_names <- gsub("\\-Z", ".Z axis", features_names)
# handle time and frequency domains
td <- grepl("^t", features_names)
features_names[td] <- paste(features_names[td], ".Time domain", sep="")
fd <- grepl("^f", features_names)
features_names[fd] <- paste(features_names[fd], ".Frequency domain", sep="")
features_names <- gsub("^t|^f", "", features_names)
# and convert to R compliant column names
features_names <- gsub("\\.\\.", "_", features_names)
features_names <- gsub("\\.", "_", features_names)
features_names <- make.names(features_names)


# add the activity and subject
col_names <- c( "Subject", "Activity", features_names)

# set the variable names
colnames(d) <- col_names

### --------------------------------------------------------------------------------
### 5. From the data set in step 4, creates a second, independent tidy data set with
### the average of each variable for each activity and each subject.
### --------------------------------------------------------------------------------

# first group by subject and activity
by_subject_activity <- group_by(d, Subject, Activity)
output <- summarise_each(by_subject_activity, funs(mean))

# now the variables are the means, so we need to update the variables names
features_names <- paste("Mean.of", features_names[], sep="_")
col_names <- c( "Subject", "Activity", features_names)
colnames(output) <- col_names

# and write this to a file
write.table(output, file = "output.txt", row.name=FALSE)