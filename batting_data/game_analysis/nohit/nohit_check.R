## nohit_check.R 

library(dplyr)
library(data.table)
library(magrittr)
library(xtable)

# game no-hit but one-or-more runs

dat = fread("teamhit.csv")
# no-hit game
dat %>% dplyr::filter(hit == 0) %>% 
  arrange(desc(year)) %>% head %>% 
  select(id, year, team, hit, score_team) %>% 
  xtable %>% 
  print(type="html")

# game no-hit but one or more runs
dat %>% dplyr::filter(hit == 0) %>% 
  dplyr::filter(score_team > 0) %>% 
  arrange(desc(year)) %>% 
  select(id, year, team, hit, score_team) %>% 
  xtable %>% 
  print(type="html")

# game no-hit but one or more runs and win the game
dat %>% dplyr::filter(hit == 0) %>% 
  dplyr::filter(score_team > score_opponent) %>%
  arrange(desc(year)) %>% 
  xtable %>% 
  print(type="html")

