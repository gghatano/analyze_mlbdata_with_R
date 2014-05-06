## onecycle_data.R 

library(data.table)
library(dplyr)
library(magrittr)

# dat = fread("../../../data/all2012.csv")
# name = fread("../../batting_data/names.csv", header=FALSE) %>% unlist
# dat %>% setnames(name)

## 1巡目の相手に対して...
## 四球, 三振, ヒットになった? 
dat_game = 
  dat %>% 
  dplyr::filter(BAT_EVENT_FL == "T") %>% 
  group_by(GAME_ID, BAT_HOME_ID) %>% 
  dplyr::summarise(H_FL = H_FL, EVENT_CD = EVENT_CD, 
                   AB_FL = AB_FL, 
                   PIT_ID = PIT_ID, 
                   EVENT_OUTS_CT = EVENT_OUTS_CT) %>%
  group_by(GAME_ID, BAT_HOME_ID) %>% 
  mutate(batter_num = 1:length(H_FL)) %>% 
  mutate(WALK = ifelse(EVENT_CD %in% c(14:16), 1, 0)) %>% 
  mutate(KO = (EVENT_CD == 3)) %>%
  mutate(HIT = ifelse(H_FL > 0, 1, 0)) %>% 
  mutate(onecycle = (batter_num <= 9))

dat_game

## 1順目被打率とそれ以外被打率 
dat_hit = 
  dat_game %>% 
  dplyr::filter(AB_FL == "T") %>% 
  group_by(PIT_ID, onecycle, add = FALSE) %>%
  dplyr::summarise(hit = sum(HIT), atbat = n())   

dat_atbat = 
  dat_hit %>% 
  group_by(PIT_ID, add = FALSE) %>% 
  summarise(atbat_all = sum(atbat)) %>% 
  inner_join(dat_hit, by = "PIT_ID")

dat_ko_bb = 
  dat_game %>% 
  group_by(PIT_ID, onecycle, add = FALSE) %>%
  dplyr::summarise(batter = n(), walk = sum(WALK), ko = sum(KO), outs = sum(EVENT_OUTS_CT)) %>% 
  inner_join(dat_atbat, by = c("PIT_ID", "onecycle"))

dat_ko_bb_all = 
  dat_ko_bb %>% 
  group_by(PIT_ID, add = FALSE) %>% 
  dplyr::summarise(batter_all = sum(batter), walk_all = sum(walk), ko_all = sum(ko),
                   outs_all = sum(outs), hit_all = sum(hit)) %>% 
  inner_join(dat_ko_bb, by = "PIT_ID")

dat_cycle = 
  dat_ko_bb_all %>% 
  select(PIT_ID, onecycle, 
         batter, batter_all, 
         walk, walk_all, 
         ko, ko_all, 
         outs, outs_all, 
         atbat, atbat_all, 
         hit, hit_all) %>% 
  dplyr::filter(outs_all >=  300)

dat_cycle
