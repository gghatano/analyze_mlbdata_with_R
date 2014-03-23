library(RPostgreSQL)
library(dplyr)
dat = fread("/Users/taku/Dropbox/works/rworks/AnalyzingBaseballData/baseball_R-master/data/Batting.csv")
dat %>% dplyr::arrange(desc(H))
fullname_and_id = 
  fread("/Users/taku/Dropbox/works/rworks/AnalyzingBaseballData/RAC2013/Master.csv") %>% 
  mutate(fullname = paste(nameFirst, nameLast, sep=" ")) %>% 
  dplyr::select(lahman40ID, fullname) %>% 
  setnames(c("playerID", "fullname"))
# 2011年までに3000本安打を超えている選手

bat_over_3000 = 
  dat %>% group_by(playerID) %>% 
  dplyr::summarise(HIT = sum(H)) %>% 
  filter(HIT >= 3000) %>% 
  select(playerID)
batters = bat_over_3000 %>% inner_join(fullname_and_id, by="playerID")
batters_data = batters %>% inner_join(dat, by = "playerID")
batters_data_hit = 
  batters_data %>%
  dplyr::select(fullname, yearID, G, AB, H, HR, SO) %>% 
  group_by(fullname, yearID) %>%
  dplyr::summarise(game = sum(G), atbat = sum(AB), hit = sum(H), homerun = sum(HR), so = sum(SO))

batters_data_hit
batters_data_career = 
  batters_data_hit %>% group_by(fullname) %>% 
  dplyr::summarise(yearID = yearID, career = yearID - min(yearID) + 1) %>% 
  inner_join(batters_data_hit, by=c("fullname", "yearID")) 

data_for_hplot = 
  batters_data_career %>%
  group_by(fullname, add=FALSE) %>% 
  dplyr::summarise(yearID = yearID, careerHit = cumsum(hit)) %>% 
  inner_join(batters_data_career, by = c("fullname", "yearID")) 

hp = hPlot(data = data_for_hplot, x="yearID", y="careerHit", group="fullname", type="line") 
hp$addFilters("recent")

np
