
## ------------------------------------------------------------------------
library(data.table)
library(dplyr)
library(reshape2)
library(xtable)

years = 1939:2013
for(year in years){
  # year = 2013
  file = paste("../../all", year, ".csv", sep="")
  dat = fread(file)
  name = fread("../names.csv", header=FALSE) %>% unlist
  dat %>% setnames(name)
  
  ## ------------------------------------------------------------------------
  dat_win = 
    dat %>% 
    group_by(GAME_ID) %>%
    dplyr::summarise(HOME_SCORE = tail(HOME_SCORE_CT,1), 
                     AWAY_SCORE = tail(AWAY_SCORE_CT,1)) %>% 
    mutate(HOME_WIN = ifelse(HOME_SCORE>AWAY_SCORE, 1, 0) )%>% 
    select(GAME_ID, HOME_WIN)
  dat_win
  
  
  ## ------------------------------------------------------------------------
  dat_select_for_wp = 
    dat %>% 
    mutate(RUNNERS= (BASE3_RUN_ID!="")*100 + (BASE2_RUN_ID!="")*10 + (BASE1_RUN_ID!="")*1) %>% 
    mutate(HOME_AWAY = HOME_SCORE_CT - AWAY_SCORE_CT) %>% 
    select(GAME_ID, INN_CT, BAT_HOME_ID, OUTS_CT, RUNNERS, HOME_AWAY)
  
  dat_select_for_wp
  
  
  ## ------------------------------------------------------------------------
  ## 試合状況と, その試合の勝ち負けとを要約する
  dat_for_wp =
    dat_select_for_wp%>% 
    merge(dat_win, by = "GAME_ID") %>%
    group_by(INN_CT, BAT_HOME_ID, OUTS_CT, RUNNERS, HOME_AWAY) %>%
    dplyr::summarise(HOME_WINS = sum(HOME_WIN==1), GAMES = n(), 
                     HOME_LOSES= sum(HOME_WIN==0)) %>%
    mutate(year = year)
  
  ## 実験::ホームゲームアドバンテージ
  dat_for_wp%>% 
    dplyr::filter(INN_CT == 1 & OUTS_CT == 0 & RUNNERS == 0 & HOME_AWAY==0 & BAT_HOME_ID == 0) %>% 
    dplyr::mutate(HOME_WIN_RATE = HOME_WINS/GAMES, AWAY_WIN_RATE = HOME_LOSES/GAMES)
  
  ## データのサイズ
  dat_for_wp %>% dim
  outputFileName = paste("./data_for_wp/data_for_wp_",year,".csv", sep="")
  write.table(file=outputFileName, x = dat_for_wp, 
              row.names=FALSE, quote=FALSE)
}



