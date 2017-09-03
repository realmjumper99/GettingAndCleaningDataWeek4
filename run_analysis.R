#************************************************************************************************************
#************************************************************************************************************
#
# This script is for the week 4 graded assignment in the "Getting and Cleaning Data" course
# offered by John Hopkins through Coursera.
# the data to be used can be found at 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
#************************************************************************************************************
#************************************************************************************************************
library(data.table)

# grab the activity labels from the second column in the text file
actLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# grab the features from the second column of the text file then getjust the mean and st. dev
features <- read.table("./UCI HAR Dataset/features.txt")[,2]
Procfeats <- grep("mean|std",features)

#************************************************************************************************************
#************************************************************************************************************
# Load in the test data
#************************************************************************************************************
#************************************************************************************************************

Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
SubTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Extract the means and standard deviations
names(Xtest) = features
Xtest <- Xtest[,Procfeats]

# Load in the activity names for y and subject name
Ytest[,2] <- actLabels[Ytest[,1]]
names(Ytest) = c("ActivityID", "Activity Labels")
names(SubTest) = "subject"

# bind the three columns into one data table
testData <- cbind(SubTest, Ytest, Xtest)

#************************************************************************************************************
#************************************************************************************************************
# Load in the training data
#************************************************************************************************************
#************************************************************************************************************

Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
Subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Extract the means and standard deviations
names(Xtrain) = features
Xtrain <- Xtrain[,Procfeats]

# Load in the activity names for y and subject name
Ytrain[,2] <- actLabels[Ytrain[,1]]
names(Ytrain) = c("ActivityID", "Activity Labels")
names(Subtrain) = "subject"

# bind the three columns into one data table
trainData <- cbind(Subtrain, Ytrain, Xtrain)

#************************************************************************************************************
#************************************************************************************************************
# Combine the data into one data set and make it tidy
#************************************************************************************************************
#************************************************************************************************************
data <- as.data.table(rbind(testData, trainData))

idLabels   = c("subject", "ActivityID", "Activity Labels")
dataLabels = setdiff(colnames(data), idLabels)
meltData      = melt.data.table(data, id = idLabels, measure.vars = dataLabels)

# Apply mean function to dataset using dcast function
tidyData   = dcast.data.table(meltData, subject + "Activity Labels" ~ variable, mean)

write.table(tidyData, file = "./tidyData.txt")


