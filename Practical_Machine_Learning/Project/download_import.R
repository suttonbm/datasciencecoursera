trainDataFileURL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
testDataFileURL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
trainDataFile <- "pml-training.csv"
testDataFile <- "pml-testing.csv"

# Download the files
if (!file.exists(trainDataFile)) {
  download.file(trainDataFileURL, trainDataFile)
}
if (!file.exists(testDataFile)) {
  download.file(testDataFileURL, testDataFile)
}

# Import the data into R
train.raw <- read.csv(trainDataFile, na.strings=c("NA", "", "#DIV/0!"))
test.raw <- read.csv(testDataFile, na.strings=c("NA", "", "#DIV/0!"))

# Downselect columns in training data set
train <- train.raw[, colSums(is.na(train.raw)) == 0]
train <- train[, -c(1:7)]
# Apply same operation so testing data set matches
test <- test.raw[, colSums(is.na(train.raw)) == 0]
test <- test[, -c(1:7)]

