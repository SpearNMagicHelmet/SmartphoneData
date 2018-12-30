# SmartphoneData
DataScience Course Final
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

The tidy dataset can be obtained by running the run_analysis.R script found in this repository.

The project remit was:
You should create one R script called run_analysis.R that does the following.
1.	Merges the training and the test sets to create one data set.
2.	Extracts only the measurements on the mean and standard deviation for each measurement.
3.	Uses descriptive activity names to name the activities in the data set
4.	Appropriately labels the data set with descriptive variable names.
5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The script in run_analysis.R will perform all of the activities required to obtain the tidy dataset.  It will download the files from the specified location, read them into R, create merged datasets and write them back to files, before creating the specified tidy dataset.

The script is commented, and performs the following process:
	# download data and read it into a dataset
	download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="smartphoneData.zip")
	fileList <- unzip("smartphoneData.zip")

	# fileList now contains a list of all of the unzipped files
	# this has also created the directory "UCI HAR Datasest" with a series of .txt files containing the data

	###################################
	# 1. Merge the training and the test sets to create one data set.
	#
	# set up merged directories
	# merge files and write them to merged directories
	########################
	# These three files are the only ones really used for the homework:  
	# *Subject* gives the primary key of the test subject
	# *X* gives the measurements themselves
	# *y* gives the activity number for the measurement
	#
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
	# although the angle values include "gravityMean," they are _using_ means, not _calculating_ them so can be discarded
	# sort the columns, and then select just these values from the main dataset
	# get the names of the measures/columns and apply to this new data subset
	# write this data subset to file

	###################################
	# 3. Change activity names to something more descriptive
	# 
	# add these values to the "y" table
	# write back to the merged y datafile

  ###################################
	# 4. Label the data set with descriptive variable names.
	#
	# step one: change the "f" and the "t" at the beginning to "Time" and "Freq"
	# step two: Add spaces after Body, Gravity, Gyro, Acc, Jerk, Mag
	# step three: Convert mean(), std() etc to more readable names

	###################################
	# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.
	#
	# Step one:  create directory
	# Step two: merge Subject ID and Activity Name onto data table
	# write to summary file
