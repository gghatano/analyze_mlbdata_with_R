data = data.table()
for (year in 2000:2013){
  filename = paste("./all", year, ".csv", sep="")
  data = rbind(data, fread(filename))
}
dat = fread("../../../data/all2013.csv", header=FALSE)
colnames = fread("names.csv", header = FALSE) %>% unlist
colnames
setnames(dat, colnames )

data_score = data %>% 
  select(GAME_ID, AWAY_SCORE_CT, HOME_SCORE_CT) %>% 
  group_by(GAME_ID) %>% 
  dplyr::summarise(away = max(AWAY_SCORE_CT), home = max(HOME_SCORE_CT)) %>%
  group_by(away, home , add=FALSE) %>% 
  dplyr::summarise(game = n())

data_score %>% arrange(desc(game))

data_score_high_low = 
  data_score %>% 
  mutate(h_l = ifelse(home > away, 
                      paste(home, "-", away, sep=""),
                      paste(away, "-", home, sep=""))) %>% 
  group_by(h_l, add=FALSE) %>% 
  dplyr::summarise(game = sum(game))
  
data_score_high_low %>% arrange(desc(game))
