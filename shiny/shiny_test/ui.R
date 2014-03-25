library(shiny)
shinyUI(
  pageWithSidebar(
    headerPanel("Hello! Shiny!"), 
    sidebarPanel(
      sliderInput("param", 
                  "parameter: t",
                  min = 0, 
                  max = 10, 
                  value = 5)
      ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)
