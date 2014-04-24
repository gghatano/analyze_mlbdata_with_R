
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
  mutate(away = max(AWAY_SCORE_CT), home = max(HOME_SCORE)) %>% 
  