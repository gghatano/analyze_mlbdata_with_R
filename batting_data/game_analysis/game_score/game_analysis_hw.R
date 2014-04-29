library(data.table)
library(dplyr)
library(magrittr)

makedata = function(filename = "all2013.csv"){
  dat = fread(paste("../../../data/", filename, sep=""), header=FALSE)
  year = substr(filename, 4, 7)
  colnames = fread("names.csv", header = FALSE) %>% unlist
  setnames(dat, colnames)
  
  # calculate the number of games of each result
  data_score = dat %>% 
    dplyr::select(GAME_ID, AWAY_SCORE_CT, HOME_SCORE_CT) %>% 
    group_by(GAME_ID) %>% 
    dplyr::summarise(away = max(AWAY_SCORE_CT), 
                     home = max(HOME_SCORE_CT)) %>%
    group_by(away, home , add=FALSE) %>% 
    dplyr::summarise(game = n(), year = year)

  return(data_score)
}

# merge the data from 1938 to 2013
dat = data.table()

# makedata() %>% group_by(add=FALSE) %>% arrange(desc(game)) %>% head(100)

files = fread("../../../data/files.txt", header=FALSE)
files_length = dim(files)[1] -1

dat = data.table()
for (N in 1:files_length){
  dat_tmp = makedata(files[N])
  dat = rbind(dat, dat_tmp)
}

dat %>% head

write.csv(dat, "gamedata.csv", quote=FALSE, row.names=FALSE)


