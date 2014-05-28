5月31日 TokyoR 
========================================================



## 野球のデータ解析: 打撃データの確認

retroSheetからダウンロードしてパースしたデータを利用します.
githubには, 2013年4月のデータがアップロードされています.

2013年全体の打撃結果データは大きすぎて, アップロードできません. 
適宜, コメントアウト部分を調整してください.

```r
library(data.table)
library(dplyr)
library(magrittr)

# 打撃結果が入ったデータファイル
# dat = fread("../../batting_data/game_analysis/dat2013_04.csv")
dat = fread("all2013.csv")
```

Read 68.1% of 190907 rowsRead 190907 rows and 97 (of 97) columns from 0.076 GB file in 00:00:03

```r
# 列名のデータです.
colname = fread("../../batting_data/names.csv", header = FALSE) %>% unlist

dat %>% setnames(colname)
# ID と フルネームのデータです
fullname = fread("../../batting_data/fullname.csv")
```


## 打率の集計

打率の計算をしてみます. 
ヒット数を打席数で割り算すればいいです.

打席イベントかどうかを表す, AB_FL(TRUEなら打席)という列があります.
ヒットかどうかは, H_FL(何塁打を打ったか)という列にあります. 

打者(BAT_ID)ごとに, 打席数とヒット数を集計します.


```r
dat %>% 
  select(BAT_ID, AB_FL, H_FL) %>%
  dplyr::filter(AB_FL == "T") %>% ## 打席イベントを抽出  
  mutate(HIT = (H_FL > 0)) %>%       ## ヒットを打ったかどうか
  group_by(BAT_ID) %>%               ## 打者ごとに
  select(-H_FL, -AB_FL) %>% 
  summarise_each(funs(sum)) %>%      ## 総和を集計する
  setnames(c("retroID", "hit")) %>%
  inner_join(fullname, by = "retroID") %>%  ## IDとフルネームを対応
  select(-retroID) %>% 
  mutate(average = hit / length(hit)) %>%  ## 打率の計算
  select(name, hit, average) %>% 
  arrange(desc(hit)) %>%           ## 並べ替え
  head(10) %>% 
  xtable %>% 
  print(type="html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Wed May 28 22:04:50 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> name </TH> <TH> hit </TH> <TH> average </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> Adrian Beltre </TD> <TD align="right"> 199 </TD> <TD align="right"> 0.21 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> Matt Carpenter </TD> <TD align="right"> 199 </TD> <TD align="right"> 0.21 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> Miguel Cabrera </TD> <TD align="right"> 193 </TD> <TD align="right"> 0.21 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> Dustin Pedroia </TD> <TD align="right"> 193 </TD> <TD align="right"> 0.21 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> Robinson Cano </TD> <TD align="right"> 190 </TD> <TD align="right"> 0.20 </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> Mike Trout </TD> <TD align="right"> 190 </TD> <TD align="right"> 0.20 </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD> Manny Machado </TD> <TD align="right"> 189 </TD> <TD align="right"> 0.20 </TD> </TR>
  <TR> <TD align="right"> 8 </TD> <TD> Eric Hosmer </TD> <TD align="right"> 188 </TD> <TD align="right"> 0.20 </TD> </TR>
  <TR> <TD align="right"> 9 </TD> <TD> Dan Murphy </TD> <TD align="right"> 188 </TD> <TD align="right"> 0.20 </TD> </TR>
  <TR> <TD align="right"> 10 </TD> <TD> Adam Jones </TD> <TD align="right"> 186 </TD> <TD align="right"> 0.20 </TD> </TR>
   </TABLE>


## 得点圏打率の計算

もっと条件のついた形で打率を計算したいと思います. 
例えば,　得点圏打率. 

ランナー状況別に打率を集計してみます. 


