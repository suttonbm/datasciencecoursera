pollutantmean <- function(directory = "specdata", pollutant = "sulfate", id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  # Create dummy data frame
  df <- data.frame(Date=character(0), sulfate=numeric(0), nitrate=numeric(0), ID=integer(0))
  
  # Open files
  for(i in id) {
    partial_Dataset = read.csv(file.path(directory, sprintf("%03d.csv", i)))
    df = rbind(partial_Dataset, df)
  }
  
  mean(na.omit(df[[pollutant]]))
}