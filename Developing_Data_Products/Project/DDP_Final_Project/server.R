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
  
  filteredData <- reactive({
    rawData.M[
        rawData.M$mag >= input$magRange[1] & 
          rawData.M$mag <= input$magRange[2] &
          rawData.M$date >= input$dateRange[1] &
          rawData.M$date <= input$dateRange[2], ]
  })
  
  output$eqMap <- renderPlot({
    generateMap(filteredData(),
                colorMap = input$colorScheme,
                input$circleScale)
  }, height = 600, width = 800)

})
