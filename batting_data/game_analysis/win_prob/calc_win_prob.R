## ------------------------------------------------------------------------
## 試合状況を入力すると, ホームの勝率を返す関数win_prob
## ...を作ろうかと思いましたが, 端末から呼ぶとバグるのでやめます. 
## シェルスクリプトから呼びやすくなるように, 
## ./win_prob.csvを変形して./yahoo_sokuhou/win_prob.csvに入れます. 

library(data.table)
library(dplyr)
library(stringr)
dir = "/Users/taku/works/analyze_mlbdata_with_R/batting_data/game_analysis/win_prob/"
dat = fread(paste(dir, "/win_prob.csv", sep=""))
dat %>% select()
base_mutate = function(base = 10){
  third = ifelse(base -100 >= 0, "3", "")
  second = ifelse(base %% 100 -10  >= 0 , "2", "")
  first = ifelse(base %% 10 > 0, "1", "" )
  zero = ifelse(base == 0, "0", "")
  base_situation = paste(first, second, third, zero, sep="")
  base_situation
}
base_mutate(0)

## データの変形
dat %>% 
  mutate(RUNNERS = base_mutate(RUNNERS)) %>% 
  mutate(HOME_WIN_PROB = round(HOME_WINS/GAMES, 3)*100) %>% 
  mutate(AWAY_WIN_PROB = round((100 - HOME_WIN_PROB, 1))) %>% 
  write.csv("./yahoo_sokuhou/win_prob.csv", quote=FALSE, row.names=FALSE)
  

