rankhospital <- function(state, outcome, num) {
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
    
    ## Sort data by hospital rank (descending)
    sub <- relevant.data[relevant.data$state == state, c(outcome, "hospital")]
    sorted.data <- sub[order(sub[,outcome], sub[,"hospital"], na.last=NA),"hospital"]
    
    ## Get requested ranking
    if(num == "best") {
        sorted.data[1]
    } else if(num == "worst") {
        tail(sorted.data, 1)[[1]]
    } else {
        sorted.data[as.numeric(num)]
    }
}