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
                  value = 3),
      selectInput("colorScheme",
                  label = "Magnitude Color Scheme:",
                  choices = c(
                    "viridis",
                    "magma",
                    "inferno",
                    "plasma"
                  )),
      textInput("loc",
                label = "Map Location:",
                value = "world"),
      width = 4
    ),
    mainPanel(
      h3("Earthquake Locations and Magnitudes"),
      plotOutput("eqMap")
    )),
  
  p("For more information, please refer to:",
    a(href='LICENSE.html', "license information"),
    " as well as ",
    a(href="DOCUMENTATION.html", "documentation"))
))
