library(maps)
library(mapproj)
library(maptools)
library(ggmap)
library(classInt)
library(viridis)

# Reference: http://gis.stackexchange.com/questions/69664/change-circle-size-according-to-value-using-r

# helper function to generate a country,
# continent, or world map with eathquakes
# overlaid.
generateMap <- function(data,
                        colorMap = "viridis",
                        circleScale = 1,
                        xlim = c(-180, 180),
                        ylim = c(-80, 80),
                        legend.title = "Earthquake Magnitude") {
  
  # Generate color map for earthquake locations
  nBreaks <- 11 # fixed color breaks
  colors <- switch(colorMap,
                   "viridis" = viridis(nBreaks),
                   "magma" = magma(nBreaks),
                   "inferno" = inferno(nBreaks),
                   "plasma" = plasma(nBreaks))
  
  # Generate classification intervals
  brks <- c(5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10)
  magBins <- cut(data$mag, breaks = brks, labels = FALSE)
  colMag <- colors[magBins]
  
  # Generate map
  map(database = "world",
      fill = TRUE,
      col = 'grey85',
      xlim = xlim,
      ylim = ylim,
      wrap = FALSE,
      resolution = 0,
      mar = c(0,0,0,0))
  points(data$lon, data$lat,
         pch = 21,
         cex = circleScale/5*magBins^2/nBreaks,
         bg = colMag,
         col = colMag)
  
  # Add a legend
  legend.text <- c("< 6",
                   "6 < 7",
                   "7 < 8",
                   "8 < 9",
                   "> 9")
  
  legend("bottomleft",
         legend = legend.text,
         fill = colors[c(2,4,6,8,10)],
         title = legend.title,
         cex = 0.75)
}