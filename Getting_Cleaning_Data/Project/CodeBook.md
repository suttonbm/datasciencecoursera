UCI HAR Dataset Cleaner - Codebook
==================================

Introduction
------------
This document will describe the variables and data contained inside `UCI_Tidy.txt`.  Additionally, it will explain how the data is joined, rearranged, and simplified from the original data set located at:

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>.

Comments on Tidy Data
---------------------
The output of this data set uses the wide format.  As such, the analysis is treated from the perspective that subject-activity combination defines an experiment, and all the averages of feature data are observations of each experiment.  Whether the wide or narrow format is "best" would depend on the analysis to be performed on the data.

For more discussion of wide vs narrow, refer to the resources below:

* [Thoughtfulbloke Blog](https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/)
* [Hadley Wickham](http://vita.had.co.nz/papers/tidy-data.pdf)

Comments on Variable Naming
---------------------------
The data contained within the tidy data set is derived from the feature data provided in the UCI data set.  Per the description from the UCI codebook:
> The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.

From the raw signals, multiple variables were derived by differentiating with respect to time (Jerk signals), splitting into magnitude/direction vectors, and transforming to frequency domain with FFT.  More information on these transformations can be found in the UCI codebook.

The column naming convention used in the tidy data set is derived straight from the naming convention used in the UCI data set.  The variable names were slightly modified to follow R requirements for variable/column names.  I chose not to make major modifications to the column names for three reasons:

* Documentation already exists in the UCI data package to explain the variable names
* Users familiar with the UCI data set may be confused if I choose an alternative naming convention
* Increasing verbosity of the column names, while potentially clearer when reading the raw data, would be a hindrance to anyone trying to make use of the dataset in R

The names were modified to meet R naming standards as follows:

* Read raw column name (e.g. tBodyAcc-mean()-X)
* Replace all "-" characters with "."
* Replace all "()" characters with ""
* The resulting column is named "tBodyAcc.mean.X"

Note: as described in the script processing section below, the column _data_ is not identical to the original UCI data set.  Each data point in the tidy data set is the _mean of all observations of a variable for a given subject and activity_.

Description of Script Processing
--------------------------------
When run, this script will perform the following operations:

* Download and unzip the UCI dataset located at the link above
* Store current working directory and change into the UCI dataset folder
* Read in feature and activity decoder ring tables:
    * `features_info.txt` - Maps feature column to feature name
    * `activity_labels.txt` - Maps activity id (integer) to description (e.g. "WALKING")
* Read in subject columns from both test and train data sets:
    * `test/subject_test.txt`
    * `train/subject_train.txt`
* Join subject tables vertically using `rbind()` to avoid rearranging data
* Read in activity columns from both test and train data sets:
    * `test/y_test.txt`
    * `train/y_train.txt`
* Join activity tables vertically using `rbind()` to avoid rearranging data
* Create named factor for activities using the activity labels decoder table.  Creating a factor provides better clustering analysis than converting to strings.
* Read in feature data from the UCI data set:
    * `test/X_test.txt`
    * `train/X_train.txt`
* Join feature data vertically using `rbind()` to avoid rearranging data
* Using the feature info decoder table, select _only_ columns relating to the mean or standard deviation of a variable using `grep()`:
    * "Mean" columns => "^[a-zA-Z]+-mean\\(\\)"
    * "Std" columns => "^[a-zA-Z]+-std\\(\\)"
* Modify feature names as described above to make them valid R names
* Select data from feature dataset based on the filter constructed above
* Join subject, activity, and filtered feature tables together using `cbind()`
* Using `ddply()`, reshape the full matrix by applying `mean()` on each column, grouped by activity and subject

The final operation on the data requires `plyr`.  See readme for installation instructions.

Variable Descriptions
---------------------
`subject.id`

* The ID number of a single subject.  Each subject is idenfitied with a unique integer value.

`activity`

* Description of the activity a particular subject performed.  Factor with six levels:
     * WALKING
     * WALKING\_UPSTAIRS
     * WALKING\_DOWNSTAIRS
     * SITTING
     * STANDING
     * LAYING

