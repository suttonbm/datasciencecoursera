###########################################################
#
#   Coursera:
#   Developing Data Products (JHU)
#   Course Project
#
#   Earthquake data loader for Shiny app.
#   
#   This script will check to ensure the earthquake data
#   exists in the data/ directory of the shiny app, and
#   download it if it does not exist.
#
#   Earthquake data is a combination of two data sources:
#     - The Global Historical Earthquake Archive (GEM)
#     - The International Seismological Centre (ISC)
#
#   GEM Data:
#   The data provided by GEM is a collection of earthquakes
#   with magnitude 7 or higher, between the years of 1000
#   and 1903. These data are based on a compilation of 
#   academic articles and studies into this historical
#   record.
#
#   ISC Data:
#   The data provided by ISC is a collection of earthquakes
#   with magnitude 5.5 or higher, between the years of 1900
#   and 2012.  These data are based on actual geological
#   observations and seismic data.
#
#   For more information on the data sources used, please
#   refer to the LICENSE.md file.
#
###########################################################

library(lubridate)

# Check that files exist.
# Shiny server will try to use "correct" exported data after
# merging if it exists.  Otherwise, data will be imported
# and merged.
#
# The ISC dataset must be requested.  If the server does not
# already have the zipfile available, the tool will not work.
GEM_RAWFILE <- "data/GEM-GHEC-v1.txt"
ISC_ZIPFILE <- "data/isc-gem.zip"
ISC_RAWFILE <- "data/isc-gem-cat.csv"
GEM_URL <- "http://www.emidius.eu/GEH/download/GEM-GHEC-v1.txt"

MERGED_DATAFILE <- "data/isc-gem-data.tab"

downloadRawFiles <- function() {
  if (!file.exists(GEM_RAWFILE)) {
    download.file(GEM_URL, GEM_RAWFILE)
    if (!file.exists(GEM_RAWFILE)) GEM_OK <- FALSE else GEM_OK <- TRUE
  }
  if (!file.exists(ISC_RAWFILE)) {
    if (!file.exists(ISC_ZIPFILE)) {
      ISC_OK <- FALSE
    } else {
      unzip(ISC_ZIPFILE)
      if (!file.exists(ISC_RAWFILE)) ISC_OK <- FALSE else ISC_OK <- TRUE
    }
  }
  
  # Read in data
  rawData.GEM <- read.table(GEM_RAWFILE,
                            sep = "\t",
                            skip = 78,
                            header = TRUE,
                            comment.char = "")
  
  rawData.ISC <- read.table(ISC_RAWFILE,
                            sep = ",",
                            strip.white = TRUE,
                            skip = 58,
                            header = TRUE,
                            comment.char = "")
  
  colNames <- c("date", "lat", "lon", "mag")
  
  # Pull used cols for GEM dataset and assign appropriate names
  rawData.GEM[is.na(rawData.GEM$Mo), "Mo"] <- 6
  rawData.GEM[is.na(rawData.GEM$Da), "Da"] <- 15
  rawData.GEM[rawData.GEM$Da == 0, "Da"] <- 15
  rawData.GEM$date <- ymd(paste(rawData.GEM$Year, "-",
                                rawData.GEM$Mo, "-",
                                rawData.GEM$Da))
  rawData.GEM.new <- rawData.GEM[, c("date", "Lat", "Lon", "M")]
  names(rawData.GEM.new) <- colNames
  
  # Pull used cols for ISC dataset and assign names
  names(rawData.ISC)[1] <- "date"
  rawData.ISC$date <- ymd_hms(rawData.ISC$date)
  rawData.ISC.new <- rawData.ISC[, c("date", "lat", "lon", "mw")]
  names(rawData.ISC.new) <- colNames
  
  # Merge data into one data frame
  rawData.M <- rbind(rawData.GEM.new, rawData.ISC.new)
  
  # Save merged data to table file
  write.table(rawData.M, MERGED_DATAFILE)
  
  return(rawData.M)
}

if (!file.exists(MERGED_DATAFILE)) {
  rawData.M <- downloadRawFiles()
} else {
  rawData.M <- read.table(MERGED_DATAFILE)
  rawData.M$date<- ymd(rawData.M$date)
}
