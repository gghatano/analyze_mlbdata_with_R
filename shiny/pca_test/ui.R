library(shiny)
shinyUI(
  pageWithSidebar(
    headerPanel("PCA (Gaussian kernel)"), 
    sidebarPanel(
      sliderInput("param", 
                  "parameter: log_10 (sigma)",
                  min = -4, 
                  max = 4, 
                  step = 0.5,
                  value = 0,
                  animate = animationOptions(interval=1250, loop=T))
      ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)
