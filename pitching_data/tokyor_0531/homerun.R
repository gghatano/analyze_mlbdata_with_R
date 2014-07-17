library(data.table)
library(magrittr)
library(dplyr)


dat = fread("../../../data/all2007.csv")
name = fread("../../batting_data/names.csv", header = FALSE) %>% unlist
dat %>% setnames(name)

dat_hr = 
  dat %>% 
  dplyr::filter(EVENT_CD == 23)
dat_hr

dat_hr %>% 
  mutate(runners = (BASE1_RUN_ID != "") + (BASE2_RUN_ID != "") + (BASE3_RUN_ID != "")) %>% 
  summarise(runs_mean = mean(runners))


