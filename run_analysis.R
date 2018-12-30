###############################
# Smartphone Data Tidying Homework
# Data Science Specialisation
#
# Author:  Simone Kusz
# Date:    23 December, 2018
#
# Reads the data from the Human Activity Reconition Using Smartphones Data Set
# and then creates and provides a tidy data set
#

run_analysis <- function(){
	# download data and read it into a dataset
	download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="smartphoneData.zip")
	fileList <- unzip("smartphoneData.zip")

	# fileList now contains a list of all of the unzipped files
	# this has also created the directory "UCI HAR Datasest" with a series of .txt files containing the data
	setwd("UCI HAR Dataset")

	###################################
	# 1. Merge the training and the test sets to create one data set.
	#
	# set up merged directories
	if(!file.exists("./merged")){
		dir.create("./merged")
	}
	if(!file.exists("./merged/Inertial Signals")){
		dir.create("./merged/Inertial Signals")
	}
	# merge files and write them to merged directories
	SimpleMerge <- function(filename){
		mergeFile1 <- read.table(paste("test/",filename,"_test.txt", sep=""))
		mergeFile2 <- read.table(paste("train/",filename,"_train.txt", sep=""))
		mergedDataSet <- rbind(mergeFile1,mergeFile2)
		if(!file.exists(paste("./merged/",filename,"_merged.txt",sep=""))){
			write.table(mergedDataSet, paste("./merged/",filename,"_merged.txt",sep=""))
		}
	}
	########################
	# These three files are the only ones really used for the homework.  
	# Subject gives the primary key of the test subject
	# X gives the measurements themselves
	# y gives the activity number for the measurement
	#
	SimpleMerge("subject")
	SimpleMerge("X")
	SimpleMerge("y")
	
	# These are the original measurements files.  Not using them for the assignment,
	# but merging anyway
	#
	for (filename in dir("test/Inertial Signals")){
		parsedname <- gsub("_test.txt","",filename)
		SimpleMerge(paste("Inertial Signals/",parsedname,sep=""))
	}

	###################################
	# 2. Extract only the measurements on the mean and standard deviation for each measurement.
	#
	# Translation:  If you take one row from each of the subject, y and X files,
	# this gives you a record of one subject (subject), one activity (y), 
	# and 561 different measurements (X)
	# these measurements are defined in the features.txt file in the root directory;
	# in other words, the features.txt file contains the column names for the X file
	# these measurements/columns include min, max, mean, and standard deviations
	# so we need to go through the features.txt file and work out which columns contain
	# mean and standard deviation measures, and extract only these for our final data set
	#
	# The mean and std measurements can be found by searching for the substring "-std" or 
	# "mean" 
	#
	
	# get the columns that contain "mean" or "std"
	# although the angle values include "gravityMean," they are using means, not calculating them so can be discarded
	library(dplyr)
	summaryDataSet <- read.table("features.txt")
	summaryDataSet <- tbl_df(summaryDataSet)

	wantedColumns <- c(
		grep("mean",summaryDataSet$V2),
		grep("std",summaryDataSet$V2))

	# sort the columns, and then select just these values from the main dataset
	wantedColumns <- sort(wantedColumns)
	allXData <- read.table("merged/X_merged.txt")
	wantedXData <- allXData[,wantedColumns]

	# get the names of the measures/columns and apply to this new data subset
	namesList <- as.list(summaryDataSet[wantedColumns,"V2"])
	names(wantedXData) <- as.character(namesList$V2)

	# write this data subset to file
	if(!file.exists("merged/means_and_std_only.txt")){
		write.table(wantedXData,"merged/means_and_std_only.txt")
	}

	###################################
	# 3. Change activity names to something more descriptive
	# 
	activities <- read.table("activity_labels.txt", stringsAsFactors = FALSE)
	activities[1,"V2"] <- "Walking Flat"
	activities[2,"V2"] <- "Walking Upstairs"
	activities[3,"V2"] <- "Walking Downstairs"
	activities[4,"V2"] <- "Sitting"
	activities[5,"V2"] <- "Standing"
	activities[6,"V2"] <- "Lying Down"

	# add these values to the "y" table
	yValues <- read.table("merged/y_merged.txt", stringsAsFactors = FALSE)
	yValues <- left_join(yValues,activities)
	names(yValues) <- c("Activity ID", "Activity Name")

	# write back to the merged y datafile
	write.table(yValues,"./merged/y_merged.txt", append=FALSE)
	

	###################################
	# 4. Label the data set with descriptive variable names.
	#

	# step one: change the "f" and the "t" at the beginning to "Time" and "Freq"
	wantedNames <- names(wantedXData)
	wantedNames <- sub("^t","Time ",wantedNames)
	wantedNames <- sub("^f","Freq ",wantedNames)

	# step two: Add spaces after Body, Gravity, Gyro, Acc, Jerk, Mag
	wantedNames <- gsub("Body", "Body ", wantedNames)
	wantedNames <- sub("Gravity", "Gravity ", wantedNames)
	wantedNames <- sub("Gyro", "Gyroscope ", wantedNames)
	wantedNames <- sub("Acc", "Accelerometer ", wantedNames)
	wantedNames <- sub("Jerk", "Jerk ", wantedNames)
	wantedNames <- sub("Mag", "Magnitude ", wantedNames)

	# step three: Convert mean(), std() etc to more readable names
	wantedNames <- sub("-mean\\(\\)-X", "X_Axis Mean", wantedNames)
	wantedNames <- sub("-mean\\(\\)-Y", "Y_Axis Mean", wantedNames)
	wantedNames <- sub("-mean\\(\\)-Z", "Z_Axis Mean", wantedNames)
	wantedNames <- sub("-std\\(\\)-X", "X_Axis StdDev", wantedNames)
	wantedNames <- sub("-std\\(\\)-Y", "Y_Axis StdDev", wantedNames)
	wantedNames <- sub("-std\\(\\)-Z", "Z_Axis StdDev", wantedNames)
	wantedNames <- sub("-meanFreq\\(\\)-X", "X_Axis Mean Frequency", wantedNames)
	wantedNames <- sub("-meanFreq\\(\\)-Y", "Y_Axis Mean Frequency", wantedNames)
	wantedNames <- sub("-meanFreq\\(\\)-Z", "Z_Axis Mean Frequency", wantedNames)

	wantedNames <- sub("-mean\\(\\)", "Mean", wantedNames)
	wantedNames <- sub("-std\\(\\)", "StdDev", wantedNames)
	wantedNames <- sub("-meanFreq\\(\\)", "Mean Frequency", wantedNames)
	wantedNames <- gsub(" ","_",wantedNames)

	names(wantedXData) <- wantedNames	

	###################################
	# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.
	#

	# Step one:  create directory
	if(!file.exists("./tidy")){
		dir.create("./tidy")
	}
	
	# Step two: merge Subject ID and Activity Name onto data table
	
	tidyDataSet <- bind_cols(yValues,wantedXData)
	subjectData <- read.table("merged/subject_merged.txt")
	tidyDataSet <- bind_cols(subjectData,tidyDataSet)
	names(tidyDataSet) <- sub("V1","Subject_ID",names(tidyDataSet))
	names(tidyDataSet) <- sub("Activity Name","Activity_Name",names(tidyDataSet))

	tidyDataSet <- select(tidyDataSet, -"Activity ID")
	tidyDataSet <- group_by(tidyDataSet,Activity_Name,Subject_ID)
	
	summarySet <- summarize_all(tidyDataSet,mean)
	# write to summary file
	if(!file.exists("./tidy/meansTable.txt")){
		write.table(summarySet,"./tidy/meansTable.txt")
	}

} # end function