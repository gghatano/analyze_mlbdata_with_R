library(shiny)
library(datasets)

shinyServer(function(input, output){
  datasetInput = reactive({
    switch(input$dataset, 
           "rock"=rock,
           "pressure" = pressure, 
           "cars" = cars, 
           "mtcars" = mtcars
           )
  })
  output$summary = renderPrint({
    dataset = datasetInput()
    summary(dataset)
  })
  output$view = renderTable({
    head(datasetInput(), n = input$obs)
  })
})