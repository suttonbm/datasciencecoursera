best <- function(state, outcome) {
    ## Outcome options
    outcomecats <- c("heart.attack", "heart.failure", "pneumonia")
    ## Read outcome data
    alldata <- read.csv("outcome-of-care-measures.csv", colClasses="character")
    ## Filter to relevant data only and shorten column names
    relevant.data <- alldata[,c(2,7,11,17,23)]
    names(relevant.data) <- c("hospital", "state", "heart.attack",
                                  "heart.failure", "pneumonia")
    relevant.data[,outcomecats] <- lapply(relevant.data[,outcomecats],
                                          as.numeric)
    
    ## Check that state and outcome are valid
    if(! state %in% relevant.data$state) {
        stop("invalid state")
    }
    outcome <- sub(" ", ".", outcome)
    if(! outcome %in% names(relevant.data)) {
        stop("invalid outcome")
    }
    
    ## Return hospital in the state with lowest 30-day mortality rate
    sub <- relevant.data[relevant.data$state == state, c(outcome, "hospital")]
    sub[order(sub[,outcome], sub[,"hospital"], na.last=NA),"hospital"][1]
}