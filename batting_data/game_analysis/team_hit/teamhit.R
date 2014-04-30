#library(xts)
library(data.table)
library(dplyr)
library(magrittr)
## calculate the number of hit in each game

teamhit = function(file = "all2013.csv"){
  year = substr(file, 4, 7)
  filename = paste("../../../../data/", file, sep="")
  dat = fread(filename)
  name = fread("../names.csv", header=FALSE) %>% unlist
  dat1 = dat %>% setnames(name) %>% 
    dplyr::select(GAME_ID, AWAY_TEAM_ID, BAT_HOME_ID, H_FL)
  
  dat_teamhit = dat1 %>% 
    setnames(c("id", "away", "h_a", "h_fl")) %>% 
    mutate(home= substr(id, 1,3)) %>% 
    mutate(hit = ifelse(h_fl > 0, 1, 0)) %>% 
    group_by(id, home, away, h_a) %>% 
    dplyr::summarise(hit = sum(hit), year = year) %>% 
    mutate(team = ifelse(h_a==1, home, away)) %>% 
    group_by(add=FALSE) %>%
    dplyr::select(id, hit, team, year) 
  return(dat_teamhit)
}

files = fread("../../../../data/files.txt", header=FALSE) %>% unlist
dat = data.table()
for(file in files){
  print(paste("file:", file))
  dat_tmp = teamhit(file)
  dat = rbind(dat, dat_tmp)
}

dat %>% write.csv("teamhit.csv", quote = FALSE, row.names=FALSE)
