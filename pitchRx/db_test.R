library(pitchRx)
library(RPostgreSQL)
library(dplyr)
library(magrittr)
library(data.table)
my_db = src_postgres("pitchrx")

pitch_data = tbl(my_db, "pitch")

pitch_data %>% dim

type_db %>% do(nrow) %>% select(DO) %>% head(3) %>% unlist %>% sum
  
years_db = group_by(batting_db, yearID)

batting_db

