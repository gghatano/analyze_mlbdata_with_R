library(data.table)
library(dplyr)
library(magrittr)

makedata = function(year = 2013){
  # set the path of data file
  filename = paste("../../../data/all", year, ".csv", sep="")
  dat = fread(filename, header=FALSE)
  colnames = fread("names.csv", header = FALSE) %>% unlist
  setnames(dat, colnames)
  
  # calculate the number of games of each result
  data_score = dat %>% 
    dplyr::select(GAME_ID, AWAY_SCORE_CT, HOME_SCORE_CT) %>% 
    group_by(GAME_ID) %>% 
    dplyr::summarise(away = max(AWAY_SCORE_CT), 
                     home = max(HOME_SCORE_CT)) %>%
    group_by(away, home , add=FALSE) %>% 
    dplyr::summarise(game = n())

  return(data_score_high_low %>% arrange(desc(game)))
}

# merge the data from 1938 to 2013
dat = data.table()
for(year in 1938:2013){
  dat = rbind(dat, makedata(year))
  print(paste("now:", year))
}

# result
result = dat %>% 
  group_by(h_l) %>% 
  dplyr::summarise(game = sum(game)) %>% 
  arrange(desc(game)) %>% 
  setnames(c("win-lose", "game")) 

write.csv(result, "result.csv", quote=FALSE, row.names=FALSE)


