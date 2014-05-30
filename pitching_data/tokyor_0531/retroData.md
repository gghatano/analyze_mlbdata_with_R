5月31日 TokyoR 打撃結果データの利用例 
========================================================



## 野球のデータ解析: 打撃データの確認

retroSheetからダウンロードしてパースしたデータを利用します.
githubに, 打撃結果のデータファイルをアップロードしてあります.

https://github.com/gghatano/analyze_mlbdata_with_R/tree/master/pitching_data/tokyor_0531

2013年主要打者100人の打撃結果のデータファイル: mainBatter.csvを使ってみることで, 
データの中身を確認してみます.


```r
library(data.table)
library(dplyr)
library(magrittr)
library(xtable)

# 打撃結果が入ったデータファイル
dat = fread("mainBatter.csv")
# ID と フルネームのデータです
fullname = fread("../../batting_data/fullname.csv")

# 1打席の状況を, 97種のデータで表現しています
dat %>% names %>% length
```

[1] 97


各打席の結果は, 97個のデータによって表現されています.
各列の意味は, http://www.retrosheet.org/datause.txt ここに書いてありますが,
これを読むのは大変です. 

以下では, 
データを使って遊びながら,
列の意味の説明を部分的に行いたいと思います.

## 打率の集計

データを利用して, 打率の計算をしてみます. 
打者ごとに, ヒット数を打席数で割り算すれば打率になります.

利用するデータ列. 

打者の名前は, BAT_IDという列に入っています.

打席イベントかどうかを表す, AB_{FL} (TRUEなら打席)という列があります.
AB_FLが TRUEのところだけ使います. FALSEの場合は, 四死球や盗塁を表します. 

また, ヒットかどうかは, H_FL(何塁打を打ったか)という列にあります.
H_FLが2なら2塁打です. 

ここだけ使えば,　打率が計算できますね.

打者名(BAT_ID)ごとに, 打席数とヒット数を集計します.


```r
dat_average = 
  dat %>% 
  select(BAT_ID, AB_FL, H_FL) %>%   ## この3列だけ使います
  mutate(HIT = (H_FL) > 0) %>%      ## ヒットかどうかだけ分かればいいです
  group_by(BAT_ID) %>% 
  summarise_each(funs(sum)) %>% 
  setnames(c("retroID", "atbat", "bases", "hit")) %>% 
  mutate(average = hit / atbat) %>% 
  inner_join(fullname, by = "retroID") %>% 
  select(name, atbat, hit, average) 

dat_average %>% 
  arrange(desc(average)) %>% 
  head(10) %>% 
  setnames(c("名前", "打席", "安打", "打率")) %>% 
  xtable(digits = 4) %>% print(type="html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Fri May 30 12:02:52 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> 名前 </TH> <TH> 打席 </TH> <TH> 安打 </TH> <TH> 打率 </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> Miguel Cabrera </TD> <TD align="right">   554 </TD> <TD align="right">   193 </TD> <TD align="right"> 0.3484 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> Michael Cuddyer </TD> <TD align="right">   489 </TD> <TD align="right">   162 </TD> <TD align="right"> 0.3313 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> Mike Trout </TD> <TD align="right">   589 </TD> <TD align="right">   190 </TD> <TD align="right"> 0.3226 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> Chris Johnson </TD> <TD align="right">   514 </TD> <TD align="right">   165 </TD> <TD align="right"> 0.3210 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> Freddie Freeman </TD> <TD align="right">   551 </TD> <TD align="right">   176 </TD> <TD align="right"> 0.3194 </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> Yadier Molina </TD> <TD align="right">   505 </TD> <TD align="right">   161 </TD> <TD align="right"> 0.3188 </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD> Jayson Werth </TD> <TD align="right">   462 </TD> <TD align="right">   147 </TD> <TD align="right"> 0.3182 </TD> </TR>
  <TR> <TD align="right"> 8 </TD> <TD> Matt Carpenter </TD> <TD align="right">   626 </TD> <TD align="right">   199 </TD> <TD align="right"> 0.3179 </TD> </TR>
  <TR> <TD align="right"> 9 </TD> <TD> Andrew McCutchen </TD> <TD align="right">   583 </TD> <TD align="right">   185 </TD> <TD align="right"> 0.3173 </TD> </TR>
  <TR> <TD align="right"> 10 </TD> <TD> Adrian Beltre </TD> <TD align="right">   631 </TD> <TD align="right">   199 </TD> <TD align="right"> 0.3154 </TD> </TR>
   </TABLE>


## 得点圏打率の計算

もっと条件のついた形で打率を計算したいと思います. 
例えば,　得点圏打率. 

ランナー状況別に打率を集計してみます. 
1塁ランナーが誰, 2塁ランナーは誰...といったデータの列があります. 

BASE1_RUN_IDが空欄かどうかを見て, ランナー状況をチェックして, group_byします.

```r
dat_runner = 
  dat %>% 
  dplyr::filter(AB_FL == TRUE) %>% 
  mutate(runner = 100*(BASE3_RUN_ID!="")+10*(BASE2_RUN_ID!="")+1*(BASE1_RUN_ID!="")) %>% 
  mutate(HIT = (H_FL > 0)) %>% 
  select(BAT_ID, runner, AB_FL, HIT) %>%
  group_by(BAT_ID, runner) %>% 
  summarise(ATBAT = sum(AB_FL), HIT = sum(HIT)) %>% 
  setnames(c("retroID", "runner", "atbat", "hit"))  %>% 
  group_by(add=FALSE) %>%
  inner_join(fullname, by = "retroID") %>%
  select(name, runner, atbat, hit) %>% 
  mutate(runner = as.integer(runner)) %>% 
  mutate(average = hit / atbat) 

dat_runner %>% 
  dplyr::filter(name == "Mike Trout") %>% 
  xtable %>% print("html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Fri May 30 12:02:53 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> name </TH> <TH> runner </TH> <TH> atbat </TH> <TH> hit </TH> <TH> average </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> Mike Trout </TD> <TD align="right">   0 </TD> <TD align="right"> 359 </TD> <TD align="right"> 122 </TD> <TD align="right"> 0.34 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> Mike Trout </TD> <TD align="right">   1 </TD> <TD align="right">  94 </TD> <TD align="right">  24 </TD> <TD align="right"> 0.26 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> Mike Trout </TD> <TD align="right">  10 </TD> <TD align="right">  48 </TD> <TD align="right">  18 </TD> <TD align="right"> 0.38 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> Mike Trout </TD> <TD align="right">  11 </TD> <TD align="right">  30 </TD> <TD align="right">   5 </TD> <TD align="right"> 0.17 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> Mike Trout </TD> <TD align="right"> 100 </TD> <TD align="right">  14 </TD> <TD align="right">   5 </TD> <TD align="right"> 0.36 </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> Mike Trout </TD> <TD align="right"> 101 </TD> <TD align="right">  21 </TD> <TD align="right">   8 </TD> <TD align="right"> 0.38 </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD> Mike Trout </TD> <TD align="right"> 110 </TD> <TD align="right">  11 </TD> <TD align="right">   5 </TD> <TD align="right"> 0.45 </TD> </TR>
  <TR> <TD align="right"> 8 </TD> <TD> Mike Trout </TD> <TD align="right"> 111 </TD> <TD align="right">  12 </TD> <TD align="right">   3 </TD> <TD align="right"> 0.25 </TD> </TR>
   </TABLE>

runnerの表示が101なら, ランナー1,3塁を意味するようにしました.
0ならランナー無し, 111なら満塁です. 
ちゃんとランナー状況別に打率が集計できています.


次に, 得点圏打率と非得点圏打率を集計してみます. 
ランナーが2塁以上にいれば, 得点圏です.得点チャンスですね. 
ランナー状況を見て, チャンスかどうかのフラグを作ってgroup_byすればいいです.

```r
dat_scoring = 
  dat_runner %>% 
  mutate(scoring = (runner >= 10)) %>% 
  select(-average, -runner) %>% 
  group_by(name, scoring) %>%
  summarise_each(funs(sum)) %>% 
  mutate(average = hit / atbat)

dat_scoring %>% 
  head() %>%
  xtable(digits=4) %>% print("html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Fri May 30 12:02:53 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> name </TH> <TH> scoring </TH> <TH> atbat </TH> <TH> hit </TH> <TH> average </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> Adam Dunn </TD> <TD> FALSE </TD> <TD align="right">   367 </TD> <TD align="right">    77 </TD> <TD align="right"> 0.2098 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> Adam Dunn </TD> <TD> TRUE </TD> <TD align="right">   158 </TD> <TD align="right">    38 </TD> <TD align="right"> 0.2405 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> Adam Jones </TD> <TD> FALSE </TD> <TD align="right">   484 </TD> <TD align="right">   129 </TD> <TD align="right"> 0.2665 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> Adam Jones </TD> <TD> TRUE </TD> <TD align="right">   169 </TD> <TD align="right">    57 </TD> <TD align="right"> 0.3373 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> Adam Lind </TD> <TD> FALSE </TD> <TD align="right">   361 </TD> <TD align="right">   105 </TD> <TD align="right"> 0.2909 </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> Adam Lind </TD> <TD> TRUE </TD> <TD align="right">   104 </TD> <TD align="right">    29 </TD> <TD align="right"> 0.2788 </TD> </TR>
   </TABLE>


### 得点圏打率(全体平均)

```r
dat_scoring %>% 
  group_by(scoring, add = FALSE) %>%
  summarise(atbat = sum(atbat), hit = sum(hit)) %>% 
  mutate(average = hit / atbat) %>% 
  xtable(digits = 4) %>% print("html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Fri May 30 12:02:53 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> scoring </TH> <TH> atbat </TH> <TH> hit </TH> <TH> average </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> FALSE </TD> <TD align="right"> 42715 </TD> <TD align="right"> 11810 </TD> <TD align="right"> 0.2765 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> TRUE </TD> <TD align="right"> 13320 </TD> <TD align="right">  3854 </TD> <TD align="right"> 0.2893 </TD> </TR>
   </TABLE>

得点圏打率と非得点圏打率が集計できました.

全体の平均を見ると, 
チャンスの場面では, 打率が1分5厘ほど高くなるみたいです.
ランナーが居ることで, 投球がやりづらくなりそうです.
また, ランナー1塁ならファーストがベースに張り付かないといけません. 
ヒットゾーンは広がりそうです.
ある程度妥当な結果でしょう. 

## チャンスになると急変する打者ランキング

得点圏, 非得点圏打率の差をとることで, チャンスになると急に強くなったり弱くなったりする打者をチェックしてみます.

```r
dat_scoring_diff = 
  dat_scoring %>% 
  select(name, scoring, average) %>% 
  reshape(timevar = "scoring", idvar = "name", direction = "wide") %>% 
  setnames(c("name", "not_scoring", "scoring")) %>% 
  mutate(average_diff = scoring - not_scoring)
```


### チャンスになると強くなる打者ランキング

```r
dat_scoring_diff %>% 
  arrange(desc(average_diff)) %>% 
  head(5) %>% 
  xtable(digits=4) %>% print("html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Fri May 30 12:02:53 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> name </TH> <TH> not_scoring </TH> <TH> scoring </TH> <TH> average_diff </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> Allen Craig </TD> <TD align="right"> 0.2672 </TD> <TD align="right"> 0.4538 </TD> <TD align="right"> 0.1867 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> Freddie Freeman </TD> <TD align="right"> 0.2810 </TD> <TD align="right"> 0.4427 </TD> <TD align="right"> 0.1618 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> Matt Holliday </TD> <TD align="right"> 0.2720 </TD> <TD align="right"> 0.3902 </TD> <TD align="right"> 0.1182 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> Michael Brantley </TD> <TD align="right"> 0.2592 </TD> <TD align="right"> 0.3750 </TD> <TD align="right"> 0.1158 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> Pablo Sandoval </TD> <TD align="right"> 0.2493 </TD> <TD align="right"> 0.3542 </TD> <TD align="right"> 0.1048 </TD> </TR>
   </TABLE>


### チャンスになると弱くなる打者ランキング

```r
dat_scoring_diff %>% 
  arrange(average_diff) %>% 
  head(5) %>%
  xtable(digits=4) %>% print("html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Fri May 30 12:02:53 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> name </TH> <TH> not_scoring </TH> <TH> scoring </TH> <TH> average_diff </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> Adrian Beltre </TD> <TD align="right"> 0.3427 </TD> <TD align="right"> 0.2412 </TD> <TD align="right"> -0.1016 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> Will Venable </TD> <TD align="right"> 0.2880 </TD> <TD align="right"> 0.2035 </TD> <TD align="right"> -0.0845 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> Anthony Rizzo </TD> <TD align="right"> 0.2467 </TD> <TD align="right"> 0.1908 </TD> <TD align="right"> -0.0559 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> Andrelton Simmons </TD> <TD align="right"> 0.2602 </TD> <TD align="right"> 0.2057 </TD> <TD align="right"> -0.0545 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> Shin-Soo Choo </TD> <TD align="right"> 0.2942 </TD> <TD align="right"> 0.2400 </TD> <TD align="right"> -0.0542 </TD> </TR>
   </TABLE>



## おまけ dplyr::doでランナー状況別打率ランキング

折角なので, 状況別に打率ランキングを出してみます.
runnnerの内容でgroupを作って, dplyr::doを使い, それぞれのランナー状況に対してランキングを作ればいいです. 

```r
dat_runner %>% 
  group_by(runner) %>% 
  do(arrange(., desc(average))) %>%
  do(head(.,3)) %>% 
  xtable(digits = 4) %>% print("html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Fri May 30 12:02:53 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> runner </TH> <TH> name </TH> <TH> atbat </TH> <TH> hit </TH> <TH> average </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD align="right">     0 </TD> <TD> Troy Tulowitzki </TD> <TD align="right">   234 </TD> <TD align="right">    80 </TD> <TD align="right"> 0.3419 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD align="right">     0 </TD> <TD> Mike Trout </TD> <TD align="right">   359 </TD> <TD align="right">   122 </TD> <TD align="right"> 0.3398 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD align="right">     0 </TD> <TD> Andrew McCutchen </TD> <TD align="right">   321 </TD> <TD align="right">   109 </TD> <TD align="right"> 0.3396 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD align="right">     1 </TD> <TD> Matt Carpenter </TD> <TD align="right">    65 </TD> <TD align="right">    26 </TD> <TD align="right"> 0.4000 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD align="right">     1 </TD> <TD> Joshua Donaldson </TD> <TD align="right">   116 </TD> <TD align="right">    46 </TD> <TD align="right"> 0.3966 </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD align="right">     1 </TD> <TD> Carlos Santana </TD> <TD align="right">   111 </TD> <TD align="right">    44 </TD> <TD align="right"> 0.3964 </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD align="right">    10 </TD> <TD> Billy Butler </TD> <TD align="right">    41 </TD> <TD align="right">    20 </TD> <TD align="right"> 0.4878 </TD> </TR>
  <TR> <TD align="right"> 8 </TD> <TD align="right">    10 </TD> <TD> Brett Gardner </TD> <TD align="right">    31 </TD> <TD align="right">    15 </TD> <TD align="right"> 0.4839 </TD> </TR>
  <TR> <TD align="right"> 9 </TD> <TD align="right">    10 </TD> <TD> Carlos Beltran </TD> <TD align="right">    42 </TD> <TD align="right">    20 </TD> <TD align="right"> 0.4762 </TD> </TR>
  <TR> <TD align="right"> 10 </TD> <TD align="right">    11 </TD> <TD> Yadier Molina </TD> <TD align="right">    42 </TD> <TD align="right">    20 </TD> <TD align="right"> 0.4762 </TD> </TR>
  <TR> <TD align="right"> 11 </TD> <TD align="right">    11 </TD> <TD> Joshua Donaldson </TD> <TD align="right">    39 </TD> <TD align="right">    18 </TD> <TD align="right"> 0.4615 </TD> </TR>
  <TR> <TD align="right"> 12 </TD> <TD align="right">    11 </TD> <TD> Freddie Freeman </TD> <TD align="right">    37 </TD> <TD align="right">    17 </TD> <TD align="right"> 0.4595 </TD> </TR>
  <TR> <TD align="right"> 13 </TD> <TD align="right">   100 </TD> <TD> Kendrys Morales </TD> <TD align="right">    17 </TD> <TD align="right">    11 </TD> <TD align="right"> 0.6471 </TD> </TR>
  <TR> <TD align="right"> 14 </TD> <TD align="right">   100 </TD> <TD> Desmond Jennings </TD> <TD align="right">    10 </TD> <TD align="right">     6 </TD> <TD align="right"> 0.6000 </TD> </TR>
  <TR> <TD align="right"> 15 </TD> <TD align="right">   100 </TD> <TD> Chris Johnson </TD> <TD align="right">    11 </TD> <TD align="right">     6 </TD> <TD align="right"> 0.5455 </TD> </TR>
  <TR> <TD align="right"> 16 </TD> <TD align="right">   101 </TD> <TD> Robinson Cano </TD> <TD align="right">    18 </TD> <TD align="right">    12 </TD> <TD align="right"> 0.6667 </TD> </TR>
  <TR> <TD align="right"> 17 </TD> <TD align="right">   101 </TD> <TD> Brian Dozier </TD> <TD align="right">    13 </TD> <TD align="right">     8 </TD> <TD align="right"> 0.6154 </TD> </TR>
  <TR> <TD align="right"> 18 </TD> <TD align="right">   101 </TD> <TD> Freddie Freeman </TD> <TD align="right">    18 </TD> <TD align="right">    11 </TD> <TD align="right"> 0.6111 </TD> </TR>
  <TR> <TD align="right"> 19 </TD> <TD align="right">   110 </TD> <TD> Jed Lowrie </TD> <TD align="right">     7 </TD> <TD align="right">     5 </TD> <TD align="right"> 0.7143 </TD> </TR>
  <TR> <TD align="right"> 20 </TD> <TD align="right">   110 </TD> <TD> Robinson Cano </TD> <TD align="right">     6 </TD> <TD align="right">     4 </TD> <TD align="right"> 0.6667 </TD> </TR>
  <TR> <TD align="right"> 21 </TD> <TD align="right">   110 </TD> <TD> Chris Johnson </TD> <TD align="right">     8 </TD> <TD align="right">     5 </TD> <TD align="right"> 0.6250 </TD> </TR>
  <TR> <TD align="right"> 22 </TD> <TD align="right">   111 </TD> <TD> Matt Carpenter </TD> <TD align="right">     9 </TD> <TD align="right">     7 </TD> <TD align="right"> 0.7778 </TD> </TR>
  <TR> <TD align="right"> 23 </TD> <TD align="right">   111 </TD> <TD> Justin Morneau </TD> <TD align="right">    14 </TD> <TD align="right">    10 </TD> <TD align="right"> 0.7143 </TD> </TR>
  <TR> <TD align="right"> 24 </TD> <TD align="right">   111 </TD> <TD> Allen Craig </TD> <TD align="right">    10 </TD> <TD align="right">     7 </TD> <TD align="right"> 0.7000 </TD> </TR>
   </TABLE>

dplyr::doはこうやって使うのですね. 
