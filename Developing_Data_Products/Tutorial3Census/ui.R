library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       p("Create demographic maps with information from the 2010 US Census"),
       selectInput("varname",
                   label = p("Choose a variable to display"),
                   choices = list("Percent White",
                                  "Percent Black",
                                  "Percent Hispanic",
                                  "Percent Asian"),
                   selected = 1),
       sliderInput("scaleRange",
                   label = p("Range of Interest:"),
                   min = 0,
                   max = 100,
                   value = c(0, 100))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       textOutput("text1"),
       textOutput("text2")
    )
  )
))
