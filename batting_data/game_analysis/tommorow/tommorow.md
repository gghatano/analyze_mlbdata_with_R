明日につながるヒット
===

## 序論
負け試合で最終回にヒットを打つと, 解説のおじさんがよく言います. 

"明日につながるヒット".

そこで今回は, 明日につながるヒットの効果を確認します. 

4点差以上で迎えた最終攻撃, ヒットを打った人を抽出. 

次の日の試合成績を確認してみます. 

## データ読み込み

```r
library(data.table)
library(pipeR)
library(dplyr)
```

2013年の全データを利用. 

```r
dat = fread("~/all2013.csv") 
```

```
## Read 99.5% of 190907 rowsRead 190907 rows and 97 (of 97) columns from 0.076 GB file in 00:00:03
```

```r
name = fread("../names.csv", header=FALSE) %>% unlist
dat %>% setnames(name)
```

## 明日につながるヒット

4点差以上で迎えた最終攻撃でヒットを打った人と, その日付を抽出. 

```r
behind_hitter = dat %>>% 
  select(GAME_ID, BAT_HOME_ID, BAT_ID, INN_CT, AWAY_SCORE_CT, HOME_SCORE_CT, H_FL) %>>% 
  mutate(DATE = as.Date(paste(substr(GAME_ID, 4,7), substr(GAME_ID, 8,9), substr(GAME_ID, 10,11), sep="-"))) %>% 
  group_by(GAME_ID) %>>%
  filter(INN_CT == max(INN_CT)) %>>% 
  filter(BAT_HOME_ID == max(BAT_HOME_ID)) %>>%
  filter(H_FL > 0) %>>%
  mutate(SCORE_DIFF = HOME_SCORE_CT - AWAY_SCORE_CT) %>>% 
  filter(SCORE_DIFF >= 4 ) %>>% 
  group_by(add=FALSE) %>>%
  select(DATE, BAT_ID)

## 先頭
behind_hitter  %>% head
```

```
##         DATE   BAT_ID
## 1 2013-04-19 huntt001
## 2 2013-04-19 cabrm001
## 3 2013-05-03 markn001
## 4 2013-05-14 peres002
## 5 2013-05-22 ryanb002
## 6 2013-06-17 ibanr001
```

```r
## 何人いるか
behind_hitter  %>% dim
```

```
## [1] 388   2
```

## 成績まとめ
試合別個人成績を集計. 

```r
## 打者別, 日付別成績
dat_days_stats = dat %>>%
  select(GAME_ID, BAT_ID, H_FL, AB_FL) %>% 
  mutate(DATE = as.Date(paste(substr(GAME_ID, 4,7), substr(GAME_ID, 8,9), substr(GAME_ID, 10,11), sep="-"))) %>% 
  select(DATE, BAT_ID, H_FL, AB_FL) %>>% 
  mutate(HIT_FL = ifelse(H_FL > 0, 1, 0)) %>% 
  group_by(DATE, BAT_ID) %>% 
  summarise(H_FL = sum(H_FL), 
            HIT_FL = sum(HIT_FL), 
            AB_FL = sum(as.logical(AB_FL))) %>% 
  group_by(add = FALSE) 

## 全体の打率を確認
dat_days_stats_summarised = 
  dat_days_stats %>% 
  summarise(H_FL = sum(H_FL), 
            HIT_FL = sum(HIT_FL),
            AB_FL = sum(AB_FL)) %>% 
  mutate(AVG = HIT_FL / AB_FL, 
         SLG= H_FL / AB_FL)
dat_days_stats_summarised
```

```
## Source: local data table [1 x 5]
## 
##    H_FL HIT_FL  AB_FL    AVG    SLG
## 1 65842  42093 166070 0.2535 0.3965
```

## "明日につながるヒット"の次の日

前日に, "明日につながるヒット"を打った人の次の日の成績

```r
behind_hitter_tommorow = 
  behind_hitter %>% 
  mutate(DATE = DATE + 1) 

dat_days_stats %>% 
  merge(behind_hitter_tommorow, by = c("DATE", "BAT_ID")) %>% 
  summarise(H_FL = sum(H_FL), 
            HIT_FL = sum(HIT_FL),
            AB_FL = sum(AB_FL)) %>% 
  mutate(AVG = HIT_FL / AB_FL, 
         SLG= H_FL / AB_FL)
```

```
##    H_FL HIT_FL AB_FL    AVG    SLG
## 1:  420    269  1034 0.2602 0.4062
```

## "明日につながるヒット"を打った人の全体打率
そもそも, "明日につながるヒット"を打った人の打率は?


```r
dat_days_stats %>% 
  merge(behind_hitter_tommorow, by = "BAT_ID") %>% 
    summarise(H_FL = sum(H_FL), 
            HIT_FL = sum(HIT_FL),
            AB_FL = sum(AB_FL)) %>% 
  mutate(AVG = HIT_FL / AB_FL, 
         SLG= H_FL / AB_FL)
```

```
##     H_FL HIT_FL  AB_FL    AVG    SLG
## 1: 62631  39690 150394 0.2639 0.4164
```

以上です. 

