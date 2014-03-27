library(dplyr)
library(Lahman)
library(magrittr)
library(rCharts)

# filter over 3000 hit batters
batting_legend_career = 
  Batting %>% as.data.table %>% 
  dplyr::select(playerID, yearID, H) %>% 
  group_by(playerID) %>% 
  dplyr::summarise(careerHit = sum(H)) %>% 
  filter(careerHit >= 3000) %>% 
  arrange(desc(careerHit))

# data of over 3000 hit batters
batting_legend_data = 
  Batting %>% as.data.table %>%  
  dplyr::select(playerID, yearID, H) %>%
  inner_join(batting_legend_career, by = "playerID")

# merge the records of the same year
batting_legend_data = 
  batting_legend_data %>% 
  as.data.table() %>%
  group_by(playerID, yearID, add=FALSE) %>% 
  dplyr::summarise(H = sum(H)) 

# calculate the cumsum of hits
batting_legend_career_data = 
  batting_legend_data %>% 
  as.data.table %>%
  group_by(playerID, add=FALSE) %>% 
  dplyr::summarise(yearID = yearID, careerH = cumsum(H), 
                   start = min(yearID), end = max(yearID))

# merge with fullname_datatable
fullname_id = fread("legends.csv") 
batting_legend_career_data_fullname = 
  batting_legend_career_data %>% inner_join(fullname_id, by = "playerID")

# make the range of career to plot
range = c(1950, 2012)
range = input$range

# filter
batting_legend_career_data_filtered = 
  batting_legend_career_data_fullname %>% 
  filter(start >= range[1] & end <= range[2]) %>% 
  select(fullname, yearID, careerH)


# make plot by using highCharts.js
hp = hPlot(data = batting_legend_career_data_filtered, careerH ~ yearID, 
           group = "fullname", 
           type = "line")
print(hp)

  
