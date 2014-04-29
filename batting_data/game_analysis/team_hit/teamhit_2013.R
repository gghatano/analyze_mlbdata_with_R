library(xts)
library(data.table)
library(dplyr)
library(magrittr)
## calculate the number of hit in each game
setwd("/Users/taku/works/analyze_mlbdata_with_R/batting_data/game_analysis/team_hit/")

file = "all2013.csv"
filename = paste("../../../../data/", file, sep="")
#dat = fread(filename)
#name = fread("../names.csv", header=FALSE) %>% unlist
dat1 = dat %>% setnames(name) %>% 
  dplyr::select(GAME_ID, AWAY_TEAM_ID, BAT_HOME_ID, H_FL)
dat_teamhit = dat1 %>% 
  setnames(c("id", "away", "h_a", "h_fl")) %>% 
  mutate(home= substr(id, 1,3)) %>% 
  mutate(hit = ifelse(h_fl > 0, 1, 0)) %>% 
  group_by(id, home, away, h_a) %>% 
  dplyr::summarise(hit = sum(hit)) %>% 
  group_by(add=FALSE) %>%
  mutate(team = ifelse(h_a==1, home, away)) 

dat_teamhit %>% 
  group_by(team) %>% 
  dplyr::summarise(hit_5game = sum(head(hit, 5)), year = 2013)
