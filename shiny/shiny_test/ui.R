library(shiny)
shinyUI(
  pageWithSidebar(
    headerPanel("Hello! Shiny!"), 
    sidebarPanel(
      sliderInput("param", 
                  "parameter: t",
                  min = 0, 
                  max = 10, 
                  step = 0.01,
                  value = 5,
                  animate = animationOptions(interval=100, loop=T))
      ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)
