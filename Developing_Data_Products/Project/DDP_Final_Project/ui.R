###########################################################
#
#   Coursera:
#   Developing Data Products (JHU)
#   Course Project
#
###########################################################

library(shiny)

shinyUI(fluidPage(
  
  # Application Title
  titlePanel("Global Earthquake Data Exploration"),
  
  # 
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("dateRange",
                     label = "Choose a date range to view:",
                     start = "1000-01-01",
                     end = "2012-12-31",
                     min = "1000-01-01",
                     max = "2012-12-31",
                     startview = "decade"),
      sliderInput("magRange",
                  label = "Choose a range of magnitudes:",
                  min = 5,
                  max = 10,
                  value = c(5,10),
                  ticks = FALSE,
                  step = 0.5,
                  animate = FALSE),
      sliderInput("circleScale",
                  label = "Magnitude Plot Scale",
                  min = 1,
                  max = 10,
                  value = 1),
      selectInput("colorScheme",
                  label = "Magnitude Color Scheme:",
                  choices = c(
                    "viridis",
                    "magma",
                    "inferno",
                    "plasma"
                  )),
      selectInput("mapLevel",
                  label = "Map Level:",
                  choices = c(
                    "world",
                    "continent",
                    "country"
                  )),
      width = 4
    ),
    mainPanel(
      plotOutput("eqMap"),
      verbatimTextOutput("data")
    ))
))
