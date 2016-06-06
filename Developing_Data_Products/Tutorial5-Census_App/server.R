# Load app libraries
library(shiny)
library(maps)
library(mapproj)

# Source helper R-scripts
source("helpers.R")

# Load data
counties <- readRDS("data/counties.rds")

# Define server-side app logic
shinyServer(function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var,
                   "w" = counties$white,
                   "k" = counties$black,
                   "h" = counties$hispanic,
                   "a" = counties$asian)
    
    color <- switch(input$var,
                    "w" = "darkgreen",
                    "k" = "darkblue",
                    "h" = "darkorange",
                    "a" = "darkviolet")
    
    legend <- switch(input$var,
                     "w" = "% White",
                     "k" = "% Black",
                     "h" = "% Hispanic",
                     "a" = "% Asian")
    
    percent_map(var = data,
                color = color,
                max = input$range[2],
                min = input$range[1],
                legend.title = legend)
  })
})
