## ------------------------------------------------------------------------
## 試合状況を入力すると, ホームの勝率を返す関数win_prob
library(data.table)
library(dplyr)
library(stringr)
# このファイルがあるディレクトリ
dir <- (function() {
  path <- (function() attr(body(sys.function(-1)), "srcfile"))()$filename
  dirname(path)
})()
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
dat %>% 
  mutate(RUNNERS = base_mutate(RUNNERS)) %>% 
  mutate(HOME_WIN_PROB = round(HOME_WINS/GAMES, 3)*100) %>% 
  mutate(AWAY_WIN_PROB = (100 - HOME_WIN_PROB)) %>% 
  write.csv("./yahoo_sokuhou/win_prob.csv", quote=FALSE, row.names=FALSE)
  
stop()

win_prob = function(INN_CT_ARG=1, BAT_HOME_ID_ARG=0, OUTS_CT_ARG=0, RUNNERS_ARG=0, HOME_AWAY_ARG=0){
  dat_win_prob =
    dat %>% 
    filter(INN_CT == INN_CT_ARG, 
           BAT_HOME_ID == BAT_HOME_ID_ARG, 
           OUTS_CT == OUTS_CT_ARG, 
           RUNNERS == RUNNERS_ARG, 
           HOME_AWAY == HOME_AWAY_ARG)  
  
    if(dim(dat_win_prob)[2]==0){
      return("データがありません")
    } else{
      dat_win_prob %>% 
        group_by(add=FALSE) %>%
        dplyr::summarise(HOME_WINS/GAMES) %>% 
        unlist %>% 
        return
    }
}

situation = fread(paste(dir,"/yahoo_sokuhou/out3.txt", sep="")) %>% unlist

## ランナー表記の調整 どうしてこうなったのか
first = (situation[4] %>% as.character %>% str_detect("1")) * 1 
second = (situation[4] %>% as.character %>% str_detect("2")) * 10 
third = (situation[4] %>% as.character %>% str_detect("3")) * 100 
situation[4] = first + second + third
situation[4] = ifelse(is.na(situation[4]), 0, situation[4])

## イニング, 裏表, アウト, ランナー状態, 点差を入力
prob = win_prob(INN_CT = situation[1], BAT_HOME_ID_ARG = situation[2], OUTS_CT_ARG = situation[3], RUNNERS_ARG = situation[4], HOME_AWAY_ARG = situation[7] - situation[6])
prob = round(prob, 3)
win_prob_set = c(1 - prob, prob)
win_prob_set %>% write.table(paste(dir, "/yahoo_sokuhou/winProb.txt", sep=""), row.names=FALSE, col.names=FALSE, quote=FALSE)
