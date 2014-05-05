## onecycle_data.R 

library(data.table)
library(dplyr)
library(magrittr)

dat = fread("../../../data/all2012.csv")
name = fread("../../batting_data/names.csv", header=FALSE) %>% unlist
dat %>% setnames(name)
