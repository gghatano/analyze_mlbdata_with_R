dat = fread("teamhit.csv") %>% 
  mutate(month = substr(id, 8,9), day = substr(id, 10,11), dh = substr(id,12,12)) %>% 
  mutate(gamedate = paste(year, month, day, dh, sep="")) %>% 
  mutate(gamedate = as.numeric(gamedate))

library(RcppRoll)

# team hit in all the 5game
dat_5game_teamhit = 
  dat %>% group_by(team, year) %>% 
  arrange(gamedate) %>%
  dplyr::summarise(hit_5game = c(roll_sum(hit, 5), rep(NA,4)), gamedate = gamedate, id = id, score = score) 

dat_5game_teamhit %>% 
  group_by(add=FALSE) %>% 
  arrange(desc(hit_5game)) %>% 
  head(10) %>%
  select(id, team, hit_5game) %>% 
  mutate(hit_5game = as.integer(hit_5game)) 
%>%
  xtable %>% 
  print(type="html")
stop()

dat %>% 
  dplyr::filter(team =="PIT") %>% 
  dplyr::filter(year=="1922") %>%
  arrange(gamedate) %>%
  dplyr::filter(gamedate>=192208050) %>%
  head(5) %>% 
  select(id, team, hit, score) %>%
  xtable %>% 
  print(type="html")

dat_opening5game = 
  dat_5game_teamhit %>% 
  group_by(team, year) %>% 
  arrange(gamedate) %>% 
  dplyr::summarise(hit_5game = head(hit_5game,1), gamedate = head(gamedate,1))

dat_opening5game %>% 
  group_by(add=FALSE) %>% 
  arrange(desc(hit_5game)) %>% 
  select(team, year, hit_5game) %>%
  mutate(hit_5game= as.integer(hit_5game)) 

dat %>% 
  dplyr::filter(team=="SFN") %>% 
  dplyr::filter(year == 1990) %>% 
  select(id, team, hit, score) %>% 
  mutate(hit = as.integer(hit)) %>% 
  head(5) %>%
  xtable %>% 
  print(type="html")
