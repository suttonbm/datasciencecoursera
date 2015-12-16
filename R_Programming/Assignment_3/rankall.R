rankall <- function(outcome, num = "best") {
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
    outcome <- sub(" ", ".", outcome)
    if(! outcome %in% names(relevant.data)) {
        stop("invalid outcome")
    }
    
    ## Iterate through all states and pull rank
    states <- unique(relevant.data$state)
    states <- states[order(states)]
    hospitals <- character(0)
    for(s in states) {
        sub <- relevant.data[relevant.data$state == s, c(outcome, "state", "hospital")]
        sorted.data <- sub[order(sub[,outcome], sub[,"hospital"], na.last=NA),"hospital"]
        
        ## Get requested ranking
        if(num == "best") {
            hospitals <- append(hospitals,sub[sub$rank == 1, "hospital"])
        } else if(num == "worst") {
            hospitals <- append(hospitals,tail(sorted.data, 1)[[1]])
        } else {
            hospitals <- append(hospitals,sorted.data[as.numeric(num)])
        }
    }
    
    data.frame(state=states, hospital=hospitals)
}