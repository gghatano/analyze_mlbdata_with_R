library(data.table)
library(magrittr)
library(dplyr)

res = fread("gamedata.csv")

res_games = res %>% 
  group_by(home, away) %>% 
  dplyr::summarise(game = sum(game))
res_games %>% arrange(desc(game)) 


res_games_hl = 
  res_games %>% 
  mutate(h_l= ifelse(home > away, 
                     paste(home, "-", away, sep=""),
                     paste(away, "-", home, sep=""))) %>% 
  group_by(h_l, add=FALSE) %>% 
  dplyr::summarise(game = sum(game)) 

library(xtable)
res_games_hl %>% arrange(desc(game)) %>% 
  xtable %>% head(10) %>% print(type="html")


res_games_hl$game %>% sum
