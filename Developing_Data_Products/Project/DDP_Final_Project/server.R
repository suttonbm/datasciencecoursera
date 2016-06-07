###########################################################
#
#   Coursera:
#   Developing Data Products (JHU)
#   Course Project
#
###########################################################

# Load required libraries
library(shiny)

# Load supporting R scripts
source("loadEarthquakeData.R")
source("generateMap.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  mapBBox <- reactive({
    tryCatch({
      # Find map bounding box
      bbox <- geocode(input$loc, output = "more", source = "dsk")
      
      # Make sure there is data in the bounding box
      if (sum(is.na(bbox[,c("north","south","east","west")])) == 0) {
        ylim <- c(bbox$south - 1,
                  bbox$north + 1)
        
        # Adjust for projection limits
        ylim <- pmax(-80, ylim)
        ylim <- pmin(80, ylim)
        
        xlim <- c(bbox$west - 1,
                  bbox$east + 1)
        
        # Adjust for projection limits
        xlim <- pmax(-180, xlim)
        xlim <- pmin(180, xlim)
      } else {
        xlim <- c(-180, 180)
        ylim <- c(-80, 80)
      }
      
      data.frame(xlim, ylim)
    }, warning = function(w) {
      data.frame("xlim" = c(-180, 180),
                 "ylim" = c(-80, 80))
    }, error = function(e) {
      data.frame("xlim" = c(-180, 180),
                 "ylim" = c(-80, 80))
    })
  })
  
  filteredData <- reactive({
    filtData <- rawData.M[rawData.M$lon >= min(mapBBox()$xlim) &
                            rawData.M$lon <= max(mapBBox()$xlim), ]
    filtData <- filtData[filtData$lat >= min(mapBBox()$ylim) &
                            filtData$lat <= max(mapBBox()$ylim), ]
    filtData <- filtData[filtData$date >= input$dateRange[1] &
                            filtData$date <= input$dateRange[2], ]
    filtData <- filtData[filtData$mag >= input$magRange[1] & 
                            filtData$mag <= input$magRange[2], ]
    filtData
  })
  
  output$eqMap <- renderPlot({
    generateMap(filteredData(),
                colorMap = input$colorScheme,
                circleScale = input$circleScale,
                xlim = mapBBox()$xlim,
                ylim = mapBBox()$ylim)
  }, width = 800)

})
