library(shiny)
library(rCharts)
library(dplyr)
library(magrittr)
library(Lahman)

# Define server logic for slider examples
shinyServer(function(input, output){
  output$chart <- reactivePlot(function(){
    
    # filter over 3000 hit batters
    batting_legend_career = 
      Batting %>% as.data.table %>% 
      dplyr::select(playerID, yearID, H) %>% 
      group_by(playerID) %>% 
      dplyr::summarise(careerHit = sum(H)) %>% 
      filter(careerHit >= 3000) %>% 
      arrange(desc(careerHit)) %>% 
      select(playerID) %>% rbind("suzukic01")
    
    # data of over 3000 hit batters
    batting_legend_data = 
      Batting %>% as.data.table %>%  
      inner_join(batting_legend_career, by = "playerID")
    
    # merge the records of the same year
    batting_legend_data = 
      batting_legend_data %>% 
      as.data.table() %>%
      group_by(playerID, yearID, add=FALSE) %>% 
      dplyr::summarise(H = sum(H), SO = sum(SO), RBI = sum(RBI), HR = sum(HR)) 
    # calculate the cumsum of hits
    batting_legend_career_data = 
      batting_legend_data %>% 
      as.data.table %>%
      group_by(playerID, add=FALSE) %>% 
      dplyr::summarise(yearID = yearID, 
                       careerHIT = cumsum(H), 
                       careerSO = cumsum(SO),
                       careerHR = cumsum(HR),
                       careerRBI = cumsum(RBI),
                       start = min(yearID), end = max(yearID))
    
    # merge with fullname_datatable
    fullname_id = fread("legends.csv") %>%
      select(playerID, fullname) %>%
      rbind( data.table(playerID = "suzukic01", fullname = "Ichiro Suzuki" ))
    
    batting_legend_career_data_fullname = 
      batting_legend_career_data %>% inner_join(fullname_id, by = "playerID")
    
    # make the range of career to plot
    # range = c(1950, 2012)
    range = input$range
    
    # filter
    batting_legend_career_data_filtered = 
      batting_legend_career_data_fullname %>% 
      filter(start >= range[1] & end <= range[2]) 
    
#     make plot by using highCharts.js
#     np = rPlot(data = batting_legend_career_data_filtered, careerH ~ yearID, 
#                color = "fullname", 
#                type = "line")
#     np
#     return(np)
#     data_for_plot = input$data
#     print(input$data)
    
    gp = ggplot(data = batting_legend_career_data_filtered, 
                aes_string(x = "yearID", y=input$data, color = "fullname")) +
      geom_point(size = 4) + geom_line(size = 1) + 
      ggtitle(input$data) + 
      theme(plot.title=element_text(size = 24, face = "bold"))
    print(gp)
  })
})