corr <- function(directory = "specdata", threshold = 0) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  ## 'threshold' is a numeric vector of length 1 indicating the
  ## number of completely observed observations (on all
  ## variables) required to compute the correlation between
  ## nitrate and sulfate; the default is 0
  
  corr = numeric(0)
  for(i in 1:332) {
    ds = read.csv(file.path(directory, sprintf("%03d.csv", i)))
    nobs = dim(na.omit(ds))[1]
    if(nobs < threshold) {
      next
    }
    corr = append(corr, cor(x=ds$nitrate, y=ds$sulfate, use="pairwise.complete.obs"))
  }
  
  corr
}