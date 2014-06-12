取られたら取り返す
========================================================



投手が取られた直後に打線が奮起. よくありますね.

取られたら取り返す. 大事です.

直前に点を取られたかどうかは, その後の攻撃に影響するんですかね?

調べてみます. 点を取られたら取り返すのかどうか.


# データ
2013年のメジャーリーグのデータを利用します. 

```r
library(data.table)
library(dplyr)

dat = fread("../../../../data/all2013.csv")
```

```
## Read 89.0% of 190907 rowsRead 190907 rows and 97 (of 97) columns from 0.076 GB file in 00:00:03
```

```r
name = fread("../names.csv", header =FALSE)

dat %>% setnames(unlist(name))
```

# 集計

各試合, 各イニングごとに, 得点を集計します.

まずは, イニング別得点.

```r
## 得点推移からイニングスコア計算する用のdiff
diff0 = function(x){
  return(diff(c(0,x)))
}

dat_inningscore = 
  dat %>% 
  group_by(GAME_ID, INN_CT, BAT_HOME_ID) %>% 
  dplyr::summarise(HOME_SCORE_CT = max(HOME_SCORE_CT), 
                   AWAY_SCORE_CT = max(AWAY_SCORE_CT)) %>% 
  group_by(GAME_ID) %>% 
  dplyr::mutate(away = diff0(AWAY_SCORE_CT), home = diff0(HOME_SCORE_CT))
dat_inningscore %>% head(9)
```

```
##        GAME_ID INN_CT BAT_HOME_ID HOME_SCORE_CT AWAY_SCORE_CT away home
## 1 ANA201304090      1           0             0             3    3    0
## 2 ANA201304090      1           1             0             3    0    0
## 3 ANA201304090      2           0             0             4    1    0
## 4 ANA201304090      2           1             0             4    0    0
## 5 ANA201304090      3           0             0             4    0    0
## 6 ANA201304090      3           1             2             4    0    2
## 7 ANA201304090      4           0             2             4    0    0
## 8 ANA201304090      4           1             2             4    0    0
## 9 ANA201304090      5           0             2             4    0    0
```

次に, 点を取られた直後かどうかを確認します.

```r
dat_afterscored =
  dat_inningscore %>% 
  group_by(GAME_ID) %>% 
  mutate(last_away = c(0,head(away, length(away)-1)), 
         last_home = c(0,head(home, length(home)-1))) %>% 
  mutate(after_scored_flg = ifelse(BAT_HOME_ID == 1, (last_away>0), (last_home>0))) %>% 
  select(GAME_ID, INN_CT, BAT_HOME_ID, after_scored_flg)
dat_afterscored %>% head
```

```
##        GAME_ID INN_CT BAT_HOME_ID after_scored_flg
## 1 ANA201304090      1           0            FALSE
## 2 ANA201304090      1           1             TRUE
## 3 ANA201304090      2           0            FALSE
## 4 ANA201304090      2           1             TRUE
## 5 ANA201304090      3           0            FALSE
## 6 ANA201304090      3           1            FALSE
```
点を取られた直後かどうかフラグを立てました. 

データフレームを結合します.

```r
dat_inning_afterscored = 
  dat_inningscore %>% 
  inner_join(dat_afterscored, by=c("GAME_ID","INN_CT","BAT_HOME_ID")) %>%
  mutate(score = ifelse(BAT_HOME_ID==1, home, away)) %>% 
  select(INN_CT, BAT_HOME_ID, after_scored_flg, score)
dat_inning_afterscored
```

```
## Source: local data table [43,799 x 5]
## Groups: GAME_ID
## 
##         GAME_ID INN_CT BAT_HOME_ID after_scored_flg score
## 1  ANA201304090      1           0            FALSE     3
## 2  ANA201304090      1           1             TRUE     0
## 3  ANA201304090      2           0            FALSE     1
## 4  ANA201304090      2           1             TRUE     0
## 5  ANA201304090      3           0            FALSE     0
## 6  ANA201304090      3           1            FALSE     2
## 7  ANA201304090      4           0             TRUE     0
## 8  ANA201304090      4           1            FALSE     0
## 9  ANA201304090      5           0            FALSE     0
## 10 ANA201304090      5           1            FALSE     0
## ..          ...    ...         ...              ...   ...
```
攻撃時に何点取れたかと, 直前に点を取られたかどうか, を用意しました.

# 集計結果
平均点を出しましょう. 1回の攻撃で何点獲ってくれるか.

```r
# 全体平均
dat_inning_afterscored %>% 
  group_by(add=FALSE) %>% 
  dplyr::summarise(score = mean(score))
```

```
## Source: local data table [1 x 1]
## 
##    score
## 1 0.4518
```

```r
# 点を取られたかどうかで場合分け
dat_inning_afterscored %>% 
  group_by(after_scored_flg, add=FALSE) %>%
  dplyr::summarise(score = mean(score))
```

```
## Source: local data table [2 x 2]
## 
##   after_scored_flg  score
## 1            FALSE 0.4531
## 2             TRUE 0.4480
```

点を取られた直後だと, 平均得点は0.448点. 
点を取られていないでは, 平均得点は0.453点. 

あまり変わりません. 

# 結論

直前に点を取られたかどうかで, 打線が特別に奮起したりしない.

# 検定

おまけです. 平均点に差があるのかどうかを検定します.
Wilcoxonの順位和検定. 


```r
after_scored = 
  dat_inning_afterscored %>% 
  dplyr::filter(after_scored_flg == TRUE) %>% 
  group_by(add=FALSE) %>%
  dplyr::select(score) %>% unlist

not_after_scored = 
  dat_inning_afterscored %>% 
  dplyr::filter(after_scored_flg == FALSE) %>% 
  group_by(add=FALSE) %>%
  dplyr::select(score) %>% unlist

test_res = wilcox.test(after_scored, not_after_scored)
test_res$p.value
```

```
## [1] 0.412
```
点を取られた直後とそうでない場合, 
打線が奮起して点を取ってくれるのかどうか. 

平均点に差があるという帰無仮説は, 有意水準5%で棄却できませんでした(p値は0.412).

# おまけ

点をとるかどうかの2値ならどうですかね?

```r
dat_inning_afterscored %>%
  mutate(score_flg = (score > 0)) %>% 
  group_by(after_scored_flg, add = FALSE) %>% 
  dplyr::summarise(score_inning = sum(score_flg), inning = n()) %>% 
  mutate(score_prob = score_inning / inning)  
```

```
## Source: local data table [2 x 4]
## 
##   after_scored_flg score_inning inning score_prob
## 1            FALSE         8459  32987     0.2564
## 2             TRUE         2730  10812     0.2525
```
はい.
