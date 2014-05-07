library(data.table)
library(reshape2)
library(dplyr)
library(magrittr)

dat = fread("pitch_cycle.csv")
# 被打率
dat_average = 
  dat %>% 
  select(name, onecycle, hit, hit_all, atbat, atbat_all) %>%
  mutate(average = round(hit/ atbat, 3)) %>% 
  select(name, onecycle, average) 

dat_average_diff = 
  dat_average %>% dcast(name ~ onecycle) %>% 
  setnames(c("name", "not_first", "first")) %>% 
  mutate(diff = first - not_first)
dat_average_diff %>% 
  arrange(diff)
