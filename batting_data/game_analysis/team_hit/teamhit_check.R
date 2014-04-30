dat = fread("teamhit.csv") %>% 
  mutate(month = substr(id, 8,9), day = substr(id, 10,11), dh = substr(id,12,12)) %>% 
  mutate(gamedate = paste(year, month, day, dh, sep="")) %>% 
  mutate(gamedate = as.numeric(gamedate))

library(RcppRoll)

# team hit in all the 5game
dat_5game_teamhit = 
  dat %>% group_by(team, year) %>% 
  dplyr::summarise(hit_5game = c(roll_sum(hit, 5), rep(NA,4)), gamedate = gamedate, id = id) 

dat_5game_teamhit %>% group_by(add=FALSE) %>% arrange(desc(hit_5game))

dat_opening5game = 
  dat_5game_teamhit %>% 
  group_by(team, year) %>% 
  arrange(gamedate) %>% 
  dplyr::summarise(hit_5game = head(hit_5game,1), gamedate = head(gamedate,1))

dat_opening5game %>% group_by(add=FALSE) %>% arrange(desc(hit_5game))
