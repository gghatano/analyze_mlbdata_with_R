dplyr::doを使う
========================================================



dplyrに新たに実装されたらしいdo関数を使います. 

group_byしてできたグループごとに関数適用した結果を見たいときに使えばいいのでしょうか. 

...でも, dplyr::summariseでもいいですよね.
結果がsingle valueではない時に使うといいんでしょうかね? 

とりあえず, vignetteをなぞってみます.


## mtcarsデータで実験.
車のデータで遊びます.

```r
mtcars %>% 
  group_by(cyl) %>% 
  do(head(., 2))
```

```
## Source: local data frame [6 x 11]
## Groups: cyl
## 
##    mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1 22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
## 2 24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
## 3 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 4 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
## 5 18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
## 6 14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
```

cyl数で分けられたdata.tableにhead(2)した結果がつながってますね. 

ピリオドは自分自身. 

次. 
各cylごとに, データに線形回帰を施した結果を見たい時. 
group_by(cyl)してからlmをすると, 
lmの結果が入ったS3クラスのデータ(?)が返ってきます. 

```r
mtcars %>% 
  group_by(cyl) %>% 
  do(mod = lm(mpg ~ disp, data = .)) 
```

```
## Source: local data frame [3 x 2]
## Groups: <by row>
## 
##   cyl     mod
## 1   4 <S3:lm>
## 2   6 <S3:lm>
## 3   8 <S3:lm>
```

data.tableでは, S3クラスのデータ(?)を持てません.
代わりに, list的なものになっているのですよね多分.

```r
mtcars %>% 
  group_by(cyl) %>% 
  do(mod = lm(mpg ~ disp, data = .)) %>%
  class
```

```
## [1] "rowwise_df" "tbl_df"     "data.frame"
```

tbl_dfってなんだろう. 分かりません. listみたいなものでしょう.

modにはcyl数で分けたデータごとにlmした結果(S3クラス)が入っているはず. 

例えば決定係数を取り出してみます. 

```r
mtcars %>% 
  group_by(cyl) %>% 
  do(mod = lm(mpg ~ disp, data = .)) %>% 
  dplyr::summarise(cyl = cyl, rsq = summary(mod)$r.squared)
```

```
## Source: local data frame [3 x 2]
## 
##   cyl     rsq
## 1   4 0.64841
## 2   6 0.01063
## 3   8 0.27016
```

できてますね. 次に, 係数を取り出してみます. 

```r
mtcars %>% 
  group_by(cyl) %>% 
  do(mod = lm(mpg ~ disp, data = .)) %>% 
  do(data.frame(cyl = .$cyl, var = names(coef(.$mod)), coef = coef(.$mod))) 
```

```
## Source: local data frame [6 x 3]
## Groups: <by row>
## 
##   cyl         var      coef
## 1   4 (Intercept) 40.871955
## 2   4        disp -0.135142
## 3   6 (Intercept) 19.081987
## 4   6        disp  0.003605
## 5   8 (Intercept) 22.032799
## 6   8        disp -0.019634
```

なるほど. 

## 野球データで

2013年4月のメジャーリーグの打席結果データを使って遊びます.



```r
dat = fread("../dat2013_04.csv")
head(dat)
```

```
##         GAME_ID AWAY_TEAM_ID INN_CT BAT_HOME_ID OUTS_CT BALLS_CT
## 1: ANA201304090          OAK      1           0       0        0
## 2: ANA201304090          OAK      1           0       1        2
## 3: ANA201304090          OAK      1           0       2        3
## 4: ANA201304090          OAK      1           0       2        3
## 5: ANA201304090          OAK      1           0       2        3
## 6: ANA201304090          OAK      1           0       2        0
##    STRIKES_CT PITCH_SEQ_TX AWAY_SCORE_CT HOME_SCORE_CT   BAT_ID
## 1:          1           CX             0             0 crisc001
## 2:          2       CBCFBX             0             0 younc004
## 3:          1        BBCBB             0             0 lowrj001
## 4:          1        BBCBB             0             0 cespy001
## 5:          1        BCBBX             0             0 norrd001
## 6:          0            X             1             0 donaj001
##    BAT_HAND_CD RESP_BAT_ID RESP_BAT_HAND_CD   PIT_ID PIT_HAND_CD
## 1:           R    crisc001                R wilsc004           L
## 2:           R    younc004                R wilsc004           L
## 3:           R    lowrj001                R wilsc004           L
## 4:           R    cespy001                R wilsc004           L
## 5:           R    norrd001                R wilsc004           L
## 6:           R    donaj001                R wilsc004           L
##    RESP_PIT_ID RESP_PIT_HAND_CD POS2_FLD_ID POS3_FLD_ID POS4_FLD_ID
## 1:    wilsc004                L    iannc001    pujoa001    kendh001
## 2:    wilsc004                L    iannc001    pujoa001    kendh001
## 3:    wilsc004                L    iannc001    pujoa001    kendh001
## 4:    wilsc004                L    iannc001    pujoa001    kendh001
## 5:    wilsc004                L    iannc001    pujoa001    kendh001
## 6:    wilsc004                L    iannc001    pujoa001    kendh001
##    POS5_FLD_ID POS6_FLD_ID POS7_FLD_ID POS8_FLD_ID POS9_FLD_ID
## 1:    calla001    aybae001    troum001    bourp001    hamij003
## 2:    calla001    aybae001    troum001    bourp001    hamij003
## 3:    calla001    aybae001    troum001    bourp001    hamij003
## 4:    calla001    aybae001    troum001    bourp001    hamij003
## 5:    calla001    aybae001    troum001    bourp001    hamij003
## 6:    calla001    aybae001    troum001    bourp001    hamij003
##    BASE1_RUN_ID BASE2_RUN_ID BASE3_RUN_ID       EVENT_TX LEADOFF_FL PH_FL
## 1:                                                  53/G       TRUE FALSE
## 2:                                                  63/G      FALSE FALSE
## 3:                                                     W      FALSE FALSE
## 4:     lowrj001                                    W.1-2      FALSE FALSE
## 5:     cespy001     lowrj001                S8/G.2-H;1-2      FALSE FALSE
## 6:     norrd001     cespy001              S56/L+.2-3;1-2      FALSE FALSE
##    BAT_FLD_CD BAT_LINEUP_ID EVENT_CD BAT_EVENT_FL AB_FL H_FL SH_FL SF_FL
## 1:          8             1        2         TRUE  TRUE    0 FALSE FALSE
## 2:          9             2        2         TRUE  TRUE    0 FALSE FALSE
## 3:          6             3       14         TRUE FALSE    0 FALSE FALSE
## 4:          7             4       14         TRUE FALSE    0 FALSE FALSE
## 5:          2             5       20         TRUE  TRUE    1 FALSE FALSE
## 6:          5             6       20         TRUE  TRUE    1 FALSE FALSE
##    EVENT_OUTS_CT DP_FL TP_FL RBI_CT WP_FL PB_FL FLD_CD BATTEDBALL_CD
## 1:             1 FALSE FALSE      0 FALSE FALSE      5             G
## 2:             1 FALSE FALSE      0 FALSE FALSE      6             G
## 3:             0 FALSE FALSE      0 FALSE FALSE      0              
## 4:             0 FALSE FALSE      0 FALSE FALSE      0              
## 5:             0 FALSE FALSE      1 FALSE FALSE      8             G
## 6:             0 FALSE FALSE      0 FALSE FALSE      5             L
##    BUNT_FL FOUL_FL BATTEDBALL_LOC_TX ERR_CT ERR1_FLD_CD ERR1_CD
## 1:   FALSE   FALSE                        0           0       N
## 2:   FALSE   FALSE                        0           0       N
## 3:   FALSE   FALSE                        0           0       N
## 4:   FALSE   FALSE                        0           0       N
## 5:   FALSE   FALSE                        0           0       N
## 6:   FALSE   FALSE                        0           0       N
##    ERR2_FLD_CD ERR2_CD ERR3_FLD_CD ERR3_CD BAT_DEST_ID RUN1_DEST_ID
## 1:           0       N           0       N           0            0
## 2:           0       N           0       N           0            0
## 3:           0       N           0       N           1            0
## 4:           0       N           0       N           1            2
## 5:           0       N           0       N           1            2
## 6:           0       N           0       N           1            2
##    RUN2_DEST_ID RUN3_DEST_ID BAT_PLAY_TX RUN1_PLAY_TX RUN2_PLAY_TX
## 1:            0            0          53                          
## 2:            0            0          63                          
## 3:            0            0          NA                          
## 4:            0            0          NA                          
## 5:            4            0          NA                          
## 6:            3            0          NA                          
##    RUN3_PLAY_TX RUN1_SB_FL RUN2_SB_FL RUN3_SB_FL RUN1_CS_FL RUN2_CS_FL
## 1:                   FALSE      FALSE      FALSE      FALSE      FALSE
## 2:                   FALSE      FALSE      FALSE      FALSE      FALSE
## 3:                   FALSE      FALSE      FALSE      FALSE      FALSE
## 4:                   FALSE      FALSE      FALSE      FALSE      FALSE
## 5:                   FALSE      FALSE      FALSE      FALSE      FALSE
## 6:                   FALSE      FALSE      FALSE      FALSE      FALSE
##    RUN3_CS_FL RUN1_PK_FL RUN2_PK_FL RUN3_PK_FL RUN1_RESP_PIT_ID
## 1:      FALSE      FALSE      FALSE      FALSE                 
## 2:      FALSE      FALSE      FALSE      FALSE                 
## 3:      FALSE      FALSE      FALSE      FALSE                 
## 4:      FALSE      FALSE      FALSE      FALSE         wilsc004
## 5:      FALSE      FALSE      FALSE      FALSE         wilsc004
## 6:      FALSE      FALSE      FALSE      FALSE         wilsc004
##    RUN2_RESP_PIT_ID RUN3_RESP_PIT_ID GAME_NEW_FL GAME_END_FL PR_RUN1_FL
## 1:                                          TRUE       FALSE      FALSE
## 2:                                         FALSE       FALSE      FALSE
## 3:                                         FALSE       FALSE      FALSE
## 4:                                         FALSE       FALSE      FALSE
## 5:         wilsc004                        FALSE       FALSE      FALSE
## 6:         wilsc004                        FALSE       FALSE      FALSE
##    PR_RUN2_FL PR_RUN3_FL REMOVED_FOR_PR_RUN1_ID REMOVED_FOR_PR_RUN2_ID
## 1:      FALSE      FALSE                                              
## 2:      FALSE      FALSE                                              
## 3:      FALSE      FALSE                                              
## 4:      FALSE      FALSE                                              
## 5:      FALSE      FALSE                                              
## 6:      FALSE      FALSE                                              
##    REMOVED_FOR_PR_RUN3_ID REMOVED_FOR_PH_BAT_ID REMOVED_FOR_PH_BAT_FLD_CD
## 1:                                                                      0
## 2:                                                                      0
## 3:                                                                      0
## 4:                                                                      0
## 5:                                                                      0
## 6:                                                                      0
##    PO1_FLD_CD PO2_FLD_CD PO3_FLD_CD ASS1_FLD_CD ASS2_FLD_CD ASS3_FLD_CD
## 1:          3          0          0           5           0           0
## 2:          3          0          0           6           0           0
## 3:          0          0          0           0           0           0
## 4:          0          0          0           0           0           0
## 5:          0          0          0           0           0           0
## 6:          0          0          0           0           0           0
##    ASS4_FLD_CD ASS5_FLD_CD EVENT_ID
## 1:           0           0        1
## 2:           0           0        2
## 3:           0           0        3
## 4:           0           0        4
## 5:           0           0        5
## 6:           0           0        6
```


打者ごとに, ヒットを打つor打たないの系列に対して連検定(tseries::runs.test)を実行. 

各打席にヒットを打つかどうかについて, ランダム性を検定してみます. 


```r
library(tseries)
runstest_res = 
  dat %>% 
  dplyr::filter(AB_FL == "TRUE") %>% ## 四死球は除いて
  mutate(HIT = as.factor(ifelse(H_FL > 0, "HIT", "NOHIT"))) %>%  ##ヒットを打ったかどうか
  group_by(BAT_ID) %>% ## 各打者ごとに
  do(res = runs.test(HIT))
runstest_res
```

```
## Source: local data table [560 x 2]
## 
##      BAT_ID        res
## 1  ackld001 <S3:htest>
## 2  adamm002 <S3:htest>
## 3  alony001 <S3:htest>
## 4  altuj001 <S3:htest>
## 5  alvap001 <S3:htest>
## 6  amara001 <S3:htest>
## 7  andir001 <S3:htest>
## 8  andre001 <S3:htest>
## 9  ankir001 <S3:htest>
## 10 aokin001 <S3:htest>
## ..      ...        ...
```


P値が小さいと, ランダムじゃない, つまり打席結果に時系列性があるんじゃないか...ということを考えています.
p.valueを取り出したいです.


```r
runstest_res %>%
  summarise(runstest_res, pval= res$p.value)
```

```
## Source: local data table [2 x 2]
```

```
## Error: Internal error: length of names (0) is not length of dt (2)
```

あれ...???? 分からん...

