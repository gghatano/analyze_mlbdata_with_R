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
year = 2013
file = paste("../../../../data/all", year, ".csv", sep="")
dat = fread(file)
```

```
## Read 94.3% of 190907 rowsRead 190907 rows and 97 (of 97) columns from 0.076 GB file in 00:00:03
```

```r
name = fread("../names.csv", header=FALSE) %>% unlist
dat %>% setnames(name)
```

試合別に, home/awayのどちらが勝ったかを調べる. 
とりあえず引き分けはホームの負けとしておく.

```r
dat_win = 
  dat %>% 
  group_by(GAME_ID) %>%
  dplyr::summarise(HOME_SCORE = tail(HOME_SCORE_CT,1), 
                   AWAY_SCORE = tail(AWAY_SCORE_CT,1)) %>% 
  mutate(HOME_WIN = ifelse(HOME_SCORE>AWAY_SCORE, 1, 0) )%>% 
  select(GAME_ID, HOME_WIN)
dat_win
```

```
## Source: local data table [2,431 x 2]
## 
##         GAME_ID HOME_WIN
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
  mutate(RUNNERS= (BASE3_RUN_ID!="")*100 + (BASE2_RUN_ID!="")*10 + (BASE1_RUN_ID!="")*1) %>% 
  mutate(HOME_AWAY = HOME_SCORE_CT - AWAY_SCORE_CT) %>% 
  select(GAME_ID, INN_CT, BAT_HOME_ID, OUTS_CT, RUNNERS, HOME_AWAY)

dat_select_for_wp
```

```
##              GAME_ID INN_CT BAT_HOME_ID OUTS_CT RUNNERS HOME_AWAY
##      1: ANA201304090      1           0       0       0         0
##      2: ANA201304090      1           0       1       0         0
##      3: ANA201304090      1           0       2       0         0
##      4: ANA201304090      1           0       2       1         0
##      5: ANA201304090      1           0       2      11         0
##     ---                                                          
## 190903: WAS201309222      9           1       0       0         0
## 190904: WAS201309222      9           1       0      10         0
## 190905: WAS201309222      9           1       1      10         0
## 190906: WAS201309222      9           1       1      11         0
## 190907: WAS201309222      9           1       1     110         0
```

結合する. 


```r
dat_for_wp =
  dat_select_for_wp%>% 
  merge(dat_win, by = "GAME_ID") %>%
  group_by(INN_CT, BAT_HOME_ID, OUTS_CT, RUNNERS, HOME_AWAY) %>%
  dplyr::summarise(HOME_LOSES = sum(HOME_WIN), GAMES = n()) %>%
  mutate(HOME_WINS = GAMES - HOME_LOSES) %>% 
  mutate(year = year)
dat_for_wp
```

```
## Source: local data table [7,853 x 9]
## Groups: INN_CT, BAT_HOME_ID, OUTS_CT, RUNNERS
## 
##    INN_CT BAT_HOME_ID OUTS_CT RUNNERS HOME_AWAY HOME_LOSES GAMES HOME_WINS
## 1       1           0       0       0        -5          0     1         1
## 2       1           0       0       0        -4          1     6         5
## 3       1           0       0       0        -3          1     4         3
## 4       1           0       0       0        -2          6    16        10
## 5       1           0       0       0        -1         11    48        37
## 6       1           0       0       0         0       1069  2432      1363
## 7       1           0       0       1        -5          0     1         1
## 8       1           0       0       1        -4          1     1         0
## 9       1           0       0       1        -2          1     8         7
## 10      1           0       0       1        -1          7    21        14
## ..    ...         ...     ...     ...       ...        ...   ...       ...
## Variables not shown: year (dbl)
```

```r
## ホームゲームアドバンテージ
dat_for_wp %>% 
  dplyr::filter(INN_CT == 1 & OUTS_CT == 0 & RUNNERS == 0 & HOME_AWAY==0 & BAT_HOME_ID == 0) %>% 
  dplyr::mutate(HOME_WIN_RATE = HOME_WINS/GAMES, AWAY_WIN_RATE = HOME_LOSES/GAMES)
```

```
## Source: local data table [1 x 11]
## Groups: INN_CT, BAT_HOME_ID, OUTS_CT, RUNNERS
## 
##   INN_CT BAT_HOME_ID OUTS_CT RUNNERS HOME_AWAY HOME_LOSES GAMES HOME_WINS
## 1      1           0       0       0         0       1069  2432      1363
## Variables not shown: year (dbl), HOME_WIN_RATE (dbl), AWAY_WIN_RATE (dbl)
```

```r
## データのサイズ
dat_for_wp %>% dim
```

```
## [1] 7853    9
```


