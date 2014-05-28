dplyr::doを使う(使うと言っていない)
========================================================




## 野球データで

2013年4月のメジャーリーグの打席結果データを使って遊びます.
コードとデータはここにあります. do.Rmdを実行します.
https://github.com/gghatano/analyze_mlbdata_with_R/tree/master/batting_data/game_analysis/summarise


```r
dat = fread("../dat2013_04.csv")
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

次に, 検定の結果が入ったS3クラスから, p.valueを取り出したいです.

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


欲しいのはp.valueだけ.
single valueなので, わざわざdplyr::doしなくても, 
dplyr::summariseでいいんじゃないかな


```r
library(tseries)
runstest_res = 
  dat %>% 
  dplyr::filter(AB_FL == "TRUE") %>% ## 四死球は除いて
  mutate(HIT = as.factor(ifelse(H_FL > 0, "HIT", "NOHIT"))) %>%  ##ヒットを打ったかどうか
  group_by(BAT_ID) %>% ## 各打者ごとに
  dplyr::summarise(p.val = (runs.test(HIT))$p.value, atbat = length(HIT))
runstest_res
```

```
## Source: local data table [560 x 3]
## 
##      BAT_ID   p.val atbat
## 1  ackld001 0.50615    91
## 2  adamm002 0.09959    24
## 3  alony001 0.28083    96
## 4  altuj001 0.94454   108
## 5  alvap001 0.31578    89
## 6  amara001 0.54047    53
## 7  andir001 0.77449    45
## 8  andre001 0.89163   100
## 9  ankir001 0.36771    51
## 10 aokin001 0.78364    96
## ..      ...     ...   ...
```


棄却された選手は誰でしょうか. 


```r
runstest_res %>% 
  dplyr::filter(p.val < 0.05) %>% 
  setnames(c("retroID", "p.val", "atbat")) %>% 
  inner_join(fread("../../fullname.csv"), by = "retroID") %>% 
  select(name, p.val, atbat)
```

```
## Source: local data table [24 x 3]
## 
##                name    p.val atbat
## 1       Erick Aybar 0.045780    32
## 2    Carlos Beltran 0.030453    88
## 3   Roger Bernadina 0.004678    18
## 4       Zack Cozart 0.026547   101
## 5       Rajai Davis 0.036776    61
## 6    Chris Denorfia 0.015146    82
## 7   Chris Dickerson 0.014490    13
## 8   Jacoby Ellsbury 0.018210   113
## 9       Jedd Gyorko 0.008393    93
## 10    Josh Hamilton 0.035043   108
## 11 Jonathan Herrera 0.018112    34
## 12     Nick Hundley 0.042797    79
## 13     Reed Johnson 0.027949    31
## 14   Dioner Navarro 0.021662    30
## 15    Ricky Nolasco 0.045500    10
## 16    Albert Pujols 0.019509   103
## 17    Nolan Reimold 0.022023    71
## 18  Wandy Rodriguez 0.033895    11
## 19       David Ross 0.015570    29
## 20      Jean Segura 0.035582    90
## 21     Nick Swisher 0.036871    83
## 22       B.J. Upton 0.021317    91
## 23  Adam Wainwright 0.014164    15
## 24     Dewayne Wise 0.015229    26
```


24人が棄却されています. 結構多いですね. 
