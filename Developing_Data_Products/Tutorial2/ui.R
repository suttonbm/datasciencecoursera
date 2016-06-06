library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Shiny Tutorial: Lesson 2"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(h3("This is the sidebar")),
    
    # Show a plot of the generated distribution
    mainPanel(
      h1("Head 1"),
      h2("Head 2"),
      h3("Head 3"),
      h4("... you get it"),
      p("This is a paragraph. It is created in HTML."),
      strong("This is bold"),
      em("This is italicized"),
      code("This is formatted as code"),
      div("This is a div with blue text", style="color:blue"),
      p("span is similar, but works for", span("groups of words", style="color:green"), "inside a paragraph."),
      a(href="#", "I can make a link"),
      tags$blockquote("Or a block quote with a citation", cite="ME"),
      hr(),
      tags$ol(tags$li("this"),tags$li("is"),tags$li("a list"))
    )
  )
))
