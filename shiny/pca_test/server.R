library(shiny)
library(ggplot2)
library(kernlab)
library(dplyr)
library(magrittr)

shinyServer(function(input, output){
  output$distPlot = reactivePlot(function(){
    param = 10^input$param 
    
    data(iris)
    iris_data = iris[, 1:4]
    iris_lab = iris[, 5]
    
    # kernel pca
    # kernel = gaussian, sigma=0.0003
    # feature dim =2
    
    result = kpca(~., data=iris_data, features=2, kpar=list(sigma=param))
    
    df = rotated(result)
    
    df_lab = 
      df %>% 
      as.data.table %>% 
      cbind(iris.lab) %>% 
      setnames(c("x", "y","species"))
    
    title = paste( "kernel PCA", "(parameter sigma = ", param, ")")
    
    gp = 
      ggplot(df_lab, aes(x=x, y=y, shape=species, col = species)) + 
      geom_point(size=4) + ggtitle(title) + 
      theme(plot.title = element_text(size = 20, face = "bold"))
    print(gp)
  })
})