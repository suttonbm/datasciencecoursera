UCI HAR Dataset Cleaner
=======================

Description
-----------
__run_analysis.R__ is an R script that will download the Human Activity Recognition data set and perform the following operations:

* Import raw data into R and merge test/train data sets
* Assign movement/activity information as a factor with descriptive labels
* Exract only "features" pertaining to mean or standard deviation of measurements (see below for definition of feature)
* Assign descriptive column names for extracted features
* Summarize average data for each feature by test subject and activity in a separate, tidy data set

The source of the original data will be downloaded from:

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

Library Requirements
--------------------
In order to run __run_analysis.R__, you will require the plyr package.  To install, type `install_packages("plyr")` at the R command line.

Usage
-----
To use, simply run __run_analysis.R__ as a script.  To do this, type `source("run_analysis.R")` at the R command line.  After running the script, a variable called `tidydata` will be available in your local environment.  This variable contains the processed data.  For more information on the columns and meanings of the data, please refer to the codebook (CodeBook.md).

Note that the data is also saved to a text file with `write_table()`.  The file name will be `UCI_Tidy.txt`.  To re-import the tidy data set, enter `data <- read_table("UCI_Tidy.txt", header=TRUE)` at the R command line.  Be sure your current working directory contains `UCI_Tidy.txt` or navigate to the correct directory first using `setwd()`.