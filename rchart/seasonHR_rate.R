library(Lahman)
library(dplyr)
library(magrittr)
library(pings)
# Batting: season stats data frame of all the players
all_data <- Batting %>% 
  select(yearID, AB, H, HR) %>%
  group_by(yearID) %>% 
  dplyr::summarise(H = sum(H, na.rm = TRUE), 
                   HR = sum(HR, na.rm = TRUE),
                   AB = sum(AB, na.rm=TRUE)) %>% 
  filter(yearID > 1900) %>% 
  mutate(HIT_rate = H / AB, HR_rate = HR / AB) %>% 
  select(yearID, HIT_rate, HR_rate) %>% 
  reshape::melt(id.vars="yearID") %>% 
  setnames(c("year", "var", "rate")) 

library(ggplot2)
all_data %>% filter(var=="HR_rate") %>% 
  ggplot() + geom_line(aes(x=year, y=rate)) + 
  ggtitle("season-HR rate") + 
  theme(plot.title=element_text(face="bold", size=24)) + 
  theme(axis.title.x=element_text(size=24)) + 
  theme(axis.title.y=element_text(size=24)) + 
  ggsave("season_HR.pdf", width=0.353*1024, height=0.353*628, unit="mm")
  
library(rCharts)
all_data_for_hplot = all_dat %>% mutate(rate = round(rate, 3))
hp = hPlot(data = all_data_for_hplot, x = "year", y = "rate", group="var", type= "line")
hp
