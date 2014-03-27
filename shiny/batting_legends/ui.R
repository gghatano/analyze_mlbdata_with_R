library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(
  #  Application title
  headerPanel("MLB Legend Batters (over 3000 hit)"),
  # Sidebar with sliders that demonstrate various available options
  sidebarPanel(
    radioButtons("data", "Data:",
               list("Hit" = "careerHIT",
                    "Homerun" = "careerHR",
                    "Strike Out" = "careerSO",
                    "RBI" = "careerRBI")),
    br(),
    sliderInput("range", "Time Span (year):",
                min = 1874, max = 2012, value = c(1900,2012))
  ),
  # Show a table summarizing the values entered
  mainPanel(
    plotOutput("chart")
    # package 'kernlab' = kernel pca
  )
))