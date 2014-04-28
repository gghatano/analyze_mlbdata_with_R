## team_hit_record.R 
## calculate the team_hit of first 5 games

library(data.table)
library(dplyr)
library(magrittr)

team_hit = function(file = "all2013.csv"){
  dat = fread(paste("../../../data/", file, sep=""))
  name= fread("names.csv", header=FALSE) %>% unlist
  year = substr(file, 4, 8)
  dat = dat %>% 
    setnames(name) %>% 
    dplyr::select(GAME_ID, AWAY_TEAM_ID, BAT_HOME_ID, H_FL)
  
  dat_teamhit = dat %>%
    setnames(c("id", "away", "h_a", "h_fl")) %>% 
    mutate(home= substr(id, 1,3)) %>% 
    mutate(hit = ifelse(h_fl > 0, 1, 0)) %>% 
    group_by(id, home, away, h_a) %>% 
    dplyr::summarise(hit = sum(hit)) %>% 
    mutate(team = ifelse(h_a==1, home, away))
  
  dat_teamhit %>% group_by(team, add=FALSE) %>% 
    dplyr::summarise(teamhit = sum(head(hit,5)), 
                     year = year) %>% 
    return
}

files = fread("../../../data/files.txt", header=FALSE) %>% unlist

dat = data.table()
for(file in files){
  dat_tmp = team_hit(file)
  dat = rbind(dat, dat_tmp)
  print(paste("now:", file))
}

dat %>% 
 write.csv("teamhit.csv", quote = FALSE, row.names=FALSE)
