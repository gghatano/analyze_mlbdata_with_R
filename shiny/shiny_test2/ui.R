library(shiny)
library(dplyr)

shinyUI(pageWithSidebar(
    headerPanel("Shiny Text"), 
    sidebarPanel(
      selectInput("dataset", "Choose a dataset:",
                  choices = c("rock", "pressure", "cars", "mtcars")),
      numericInput("obs", "Number of observations to view;", 10)
    ),
    
    mainPanel(
      verbatimTextOutput("summary"), 
      tableOutput("view")
    )
))
      