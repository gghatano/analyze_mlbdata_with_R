library(data.table)
library(dplyr)
library(magrittr)


makedata = function(year = 2013){
  filename = paste("../../../data/all", year, ".csv", sep="")
  dat = fread(filename, header=FALSE)
  colnames = fread("names.csv", header = FALSE) %>% unlist
  setnames(dat, colnames)

  data_score = dat %>% 
    dplyr::select(GAME_ID, AWAY_SCORE_CT, HOME_SCORE_CT) %>% 
    group_by(GAME_ID) %>% 
    dplyr::summarise(away = max(AWAY_SCORE_CT), 
                     home = max(HOME_SCORE_CT)) %>%
    group_by(away, home , add=FALSE) %>% 
    dplyr::summarise(game = n())

  data_score_high_low = 
    data_score %>% 
    mutate(h_l = ifelse(home > away, 
                        paste(home, "-", away, sep=""),
                        paste(away, "-", home, sep=""))) %>% 
    group_by(h_l, add=FALSE) %>% 
    dplyr::summarise(game = sum(game), year = year) 
  return(data_score_high_low %>% arrange(desc(game)))
}

dat = data.table()
for(year in 1950:2013){
  dat = rbind(dat, makedata(year))
  print(paste("now:", year))
}


dat %>% 
  group_by(h_l) %>% 
  dplyr::summarise(game = sum(game)) %>% 
  arrange(desc(game)) %>% 
  head
