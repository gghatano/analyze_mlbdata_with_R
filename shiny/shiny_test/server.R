library(shiny)
library(ggplot2)
shinyServer(function(input, output){
  
  output$distPlot = reactivePlot(function(){
    param = input$param
    x = seq(0,10, by = 0.01)
    y = sin(param * x)
    df = data.frame(x=x, y=y)
    f = df %>% ggplot(aes(x=x, y=y)) + geom_line()
    print(f)
  })
})