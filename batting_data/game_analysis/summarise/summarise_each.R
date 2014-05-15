# summarise_each.R

# summarise the batting_data with dplyr summarise_each

# install_github("hadley/dplyr", ref="colwise")
library(dplyr)
library(data.table)
library(magrittr)

dat = fread("../../../../data/all2013.csv")
names = fread("../names.csv", header=FALSE) %>% unlist
dat %>% setnames(names)

# select the HIT flag and ATBAT flag
dat_bat = 
  dat %>% select(BAT_ID, H_FL, AB_FL) %>% 
  mutate(AB_FL = ifelse(AB_FL == "T", 1, 0)) %>% 
  mutate(H_FL = ifelse(H_FL > 0, 1, 0))

# calculate the average by using summarise_each
dat_bat %>% 
  group_by(BAT_ID) %>% 
  summarise_each(funs(sum)) %>% 
  dplyr::filter(AB_FL != 0) %>% 
  mutate(average = H_FL / AB_FL) %>% 
  setnames(c("batter", "hit", "atbat", "average")) %>% 
  arrange(desc(hit))
