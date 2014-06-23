Win-probability
========================================================


イニング, 裏表, 点差, ランナー状況別に, 勝率を集計したいです. 

例えば, 2点ビハインドの7回裏で, 2アウト満塁の場面から勝つ確率は何%か, みたいなことを知りたいです. 

データ読み込み.

```r
library(data.table)
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
##  以下のオブジェクトはマスクされています (from 'package:data.table') : 
## 
##      last 
## 
##  以下のオブジェクトはマスクされています (from 'package:stats') : 
## 
##      filter, lag 
## 
##  以下のオブジェクトはマスクされています (from 'package:base') : 
## 
##      intersect, setdiff, setequal, union
```

```r
library(reshape2)
library(xtable)
dat = fread("../../../../data/all2013.csv")
```

```
## Read 99.5% of 190907 rowsRead 190907 rows and 97 (of 97) columns from 0.076 GB file in 00:00:03
```

```r
name = fread("../names.csv", header=FALSE) %>% unlist
dat %>% setnames(name)
```

試合別に, home/awayのどちらが勝ったかを調べる. 

```r
dat_win = 
  dat %>% 
  group_by(GAME_ID) %>%
  dplyr::summarise(home = tail(HOME_SCORE_CT,1), 
                   away = tail(AWAY_SCORE_CT,1)) %>% 
  mutate(home_win = ifelse(home > away, 1,0)) %>% 
  select(GAME_ID, home_win)
dat_win
```

```
## Source: local data table [2,431 x 2]
## 
##         GAME_ID home_win
## 1  ANA201304090        0
## 2  ANA201304100        0
## 3  ANA201304110        0
## 4  ANA201304120        0
## 5  ANA201304130        0
## 6  ANA201304140        1
## 7  ANA201304190        1
## 8  ANA201304200        1
## 9  ANA201304210        0
## 10 ANA201304220        0
## ..          ...      ...
```

ランナー状況, イニング, 点差を抽出する.

```r
dat_select_for_wp = 
  dat %>% 
  mutate(runners = (BASE3_RUN_ID!="")*100 + (BASE2_RUN_ID!="")*10 + (BASE1_RUN_ID!="")*1) %>% 
  mutate(home_away = HOME_SCORE_CT - AWAY_SCORE_CT) %>% 
  select(GAME_ID, INN_CT, BAT_HOME_ID, OUTS_CT, runners, home_away)

dat_for_wp
```

```
## Error: オブジェクト 'dat_for_wp' がありません
```

結合する. 



```r
dat_for_wp =
  dat_select_for_wp %>% 
  dplyr::inner_join(dat_win, by = "GAME_ID") %>% 
  group_by(INN_CT, BAT_HOME_ID, OUTS_CT, runners, home_away) %>%
  dplyr::summarise(home_wins = sum(home_win), games = n()) %>%
  mutate(home_loses = games - home_wins)

## ホームゲームアドバンテージ
```


