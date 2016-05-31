library(lubridate)
oldStormData <- stormData

# Utility function for cleaning strings
cleanStr <- function(s) {
  s <- gsub("^\\s+|\\s+$", "", s)
  s <- gsub("[[:punct:]]", " ", s)
  toupper(s)
}

# Utility function for cleaning EVTYPE
# ASSUMPTIONS:
# The data input into this column is highly irregular and does not
# conform to a particular set of valid entries. I have attempted to
# standardize the names as much as possible. There are still a large
# number of entries with unique values that have not been addressed.
# In addition, it is possible that some events have multiple types
# in the description. I make no assumption about "importance" when
# assigning the single category to an event. Names are filtered
# roughly alphabetically using `grep`, and secondary event types
# are most likely removed.
mapEVTYPE <- function(v) {
  v[grep("ASTRO.+LOW", v)] <- "ASTRONOMICAL LOW TIDE"
  v[grep("ASTRO.+HIGH", v)] <- "ASTRONOMICAL HIGH TIDE"
  v[grep("AVAL", v)] <- "AVALANCHE"
  v[grep("BLIZ", v)] <- "BLIZZARD"
  v[grep("COAST.+FLOOD", v)] <- "COASTAL FLOOD"
  v[grep("CHILL", v)] <- "WIND CHILL"
  v[grep("DENSE.+FOG", v)] <- "DENSE FOG"
  v[grep("SMOKE", v)] <- "SMOKE"
  v[grep("DROUG", v)] <- "DROUGHT"
  v[grep("DEV[IE]L", v)] <- "DUST DEVIL"
  v[grep("DUST *ST", v)] <- "DUST STORM"
  v[grep("SAHARA", v)] <- "DUST STORM"
  v[grep("EXCESS.+HEAT", v)] <- "EXCESS HEAT"
  v[grep("EXTR.+COLD", v)] <- "EXTREME COLD"
  v[grep("FLASH", v)] <- "FLASH FLOOD"
  v[setdiff(grep("FLOOD", v), grep("FLASH", v))] <- "FLOOD"
  v[grep("FRE.+FOG", v)] <- "FREEZING FOG"
  v[grep("FROS", v)] <- "FROST/FREEZE"
  v[grep("FUN", v)] <- "FUNNEL CLOUD"
  v[grep("HAIL", v)] <- "HAIL"
  v[grep("HEAT", v)] <- "EXCESS HEAT"
  v[grep("HEAV.+(RAIN|PREC)", v)] <- "HEAVY RAIN"
  v[grep("HEAV.+SNOW", v)] <- "HEAVY SNOW"
  v[grep("SURF", v)] <- "HEAVY SURF"
  v[grep("HURR", v)] <- "HURRICANE"
  v[grep("ICE", v)] <- "ICE STORM"
  v[grep("SLEE", v)] <- "SLEET"
  v[grep("THUNDER", v)] <- "THUNDERSTORM"
  v[grep("TSTM", v)] <- "THUNDERSTORM"
  v[grep("WATERSPOUT", v)] <- "WATERSPOUT"
  v[grep("TORN", v)] <- "TORNADO"
  v[grep("DEPR", v)] <- "TROPICAL DEPRESSION"
  v[grep("TROP.+STORM", v)] <- "TROPICAL STORM"
  v[grep("TSU", v)] <- "TSUNAMI"
  v[grep("VOL.+ASH", v)] <- "VOLCANIC ASH"
  v[grep("WILD", v)] <- "WILDFIRE"
  v[grep("WINT", v)] <- "WINTER STORM"
  v[grep("LIGHTN", v)] <- "LIGHTNING"
  v[grep("HIGH.+WIND", v)] <- "STRONG WIND"
  v[grep("STRONG", v)] <- "STRONG WIND"
  v[grep("SUMMARY", v)] <- NA
  return(v)
}

# Function for extracting exponent for PROPDMG and CROPDMG
# ASSUMPTIONS:
# There are both numeric and character values in the
# PROPDMGEXP and CROPDMGEXP variables. For numeric values,
# I have assumed that this is a power of ten multiplying
# PROPDMG or CROPDMG. For character values, I have assumed
# this variable refers to a particular power of ten
# (e.g. "M" -> Million -> $1,000,000 x PROPDMG).
# Where the value does not fit either of these criteria,
# I ignore the value of this variable (i.e, exponent = 1)
getExp <- function(v) {
  v[grep("0", v)] <- "1"
  v[grep("1", v)] <- "10"
  v[grep("[2H]", v)] <- "100"
  v[grep("[3K]", v)] <- "1000"
  v[grep("4", v)] <- "10000"
  v[grep("5", v)] <- "100000"
  v[grep("[6M]", v)] <- "1000000"
  v[grep("7", v)] <- "10000000"
  v[grep("8", v)] <- "100000000"
  v[grep("[9B]", v)] <- "1000000000"
  v <- as.numeric(v)
  v[is.na(v)] <- 1
  return(v)
}

# Convert BGN_DATE factor -> datetime
stormData$BGN_DATE <- date(mdy_hms(stormData$BGN_DATE))

# Convert END_DATE factor -> datetime
stormData$END_DATE <- date(mdy_hms(stormData$END_DATE))
# Fix missing END_DATE
# ASSUMPTIONS:
# Where END_DATE is not specified in the database, I make the assumption
# that the event does not last longer than 24 hours. In essence, I assign
# END_DATE = BGN_DATE
stormData$END_DATE[is.na(stormData$END_DATE)] <-
  stormData$BGN_DATE[is.na(stormData$END_DATE)]

# Clean EVTYPE
stormData$EVTYPE <- unlist(lapply(stormData$EVTYPE, cleanStr))
stormData$EVTYPE <- factor(mapEVTYPE(stormData$EVTYPE))

# Clean PROPDMG
stormData$PROPDMGEXP <- unlist(lapply(stormData$PROPDMGEXP, cleanStr))
stormData$PROPDMGEXPN <- getExp(stormData$PROPDMGEXP)
stormData$PROPDMG <- stormData$PROPDMG * stormData$PROPDMGEXPN

# Clean CROPDMG
stormData$CROPDMGEXP <- unlist(lapply(stormData$CROPDMGEXP, cleanStr))
stormData$CROPDMGEXPN <- getExp(stormData$CROPDMGEXP)
stormData$CROPDMG <- stormData$CROPDMG * stormData$CROPDMGEXPN

# Create TOTALDMG
stormData$TOTALDMG <- stormData$CROPDMG + stormData$PROPDMG

# Remove unused columns
usedCols = c("BGN_DATE", "TIME_ZONE", "STATE", "EVTYPE", "END_DATE",
             "LENGTH", "WIDTH", "F", "MAG", "FATALITIES", "INJURIES",
             "PROPDMG", "CROPDMG", "TOTALDMG")
stormData <- stormData[, usedCols]
stormData <- stormData[sample(nrow(stormData), 1000), ]