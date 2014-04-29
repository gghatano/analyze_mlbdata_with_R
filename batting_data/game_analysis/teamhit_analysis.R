library(data.table)
library(dplyr)
library(magrittr)

dat = fread("teamhit.csv")
dat %>% arrange(desc(teamhit))
