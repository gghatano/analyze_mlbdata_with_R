library(data.table)
library(magrittr)
library(dplyr)

dat = fread("teamhit_all.csv")

dat %>% arrange(desc(hit))

