期待打点の集計
========================================================

勝負強さが知りたいです. 点をとってくれる打者を評価したいです.
勝負強さの指標である得点圏打率には, 打点が反映されていません. 
しかし,　生の打点の数字は, 打順に依存します.
勝負強くない打者でも, チャンスの場面でたくさん打席が回ってくれば, 勝手に打点が上がっていきます. 


ここで, ランナー状況, アウトカウント別に, 打点の期待値を計算してみました. 

たとえば,

「1アウト2, 3塁で迎えた打席では何点生まれるのか」　

などの集計を行った, ということです. 

そして, 各バッターが, 各打席で期待打点をどれくらい上回ったか...という計算を行うことによって,
得点能力が分かりませんかね? 

ちょっとやってみます. まだ途中ですけど. 


データ読み込み. 2013年の全打席結果.

```r
library(data.table)
library(dplyr)
library(xtable)

year = 2013
file = paste("../../../../data/all", year, ".csv", sep="")
dat = fread(file)
```

Read 94.3% of 190907 rowsRead 190907 rows and 97 (of 97) columns from 0.076 GB file in 00:00:03

```r
names = fread("../names.csv", header = FALSE) %>% unlist
dat %>% setnames(names)
```

ランナー状況を確認. "100"なら, ランナー3塁です. 
各バッターについて, アウトカウントとランナー状況別, 打席数と挙げた打点を集計.

```r
dat_rbi = 
  dat %>% 
  #dplyr::filter(AB_FL == "T") %>% 
  mutate(runner = (BASE1_RUN_ID != "")*1 + (BASE2_RUN_ID != "")*10 + (BASE3_RUN_ID != "")*100) %>% 
  mutate(runner = as.integer(runner)) %>%
  select(BAT_ID, OUTS_CT, runner, RBI_CT) %>%
  group_by(BAT_ID, OUTS_CT, runner) %>% 
  dplyr::summarise(atbat = n(), RBI = sum(RBI_CT)) 

dat_rbi %>% head %>% xtable %>% print("html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Wed Jun  4 22:15:23 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> BAT_ID </TH> <TH> OUTS_CT </TH> <TH> runner </TH> <TH> atbat </TH> <TH> RBI </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> abret001 </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">  30 </TD> <TD align="right">   0 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> abret001 </TD> <TD align="right">   0 </TD> <TD align="right">   1 </TD> <TD align="right">  10 </TD> <TD align="right">   0 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> abret001 </TD> <TD align="right">   0 </TD> <TD align="right">  10 </TD> <TD align="right">   1 </TD> <TD align="right">   0 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> abret001 </TD> <TD align="right">   0 </TD> <TD align="right">  11 </TD> <TD align="right">   2 </TD> <TD align="right">   0 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> abret001 </TD> <TD align="right">   0 </TD> <TD align="right"> 100 </TD> <TD align="right">   1 </TD> <TD align="right">   0 </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> abret001 </TD> <TD align="right">   0 </TD> <TD align="right"> 101 </TD> <TD align="right">   1 </TD> <TD align="right">   0 </TD> </TR>
   </TABLE>
まずは全体平均. 
ランナー状況ごとに打点を計算. 

```r
dat_rbi_all = 
  dat_rbi %>%
  group_by(runner, OUTS_CT) %>%
  dplyr::summarise(atbat = sum(atbat), RBI = sum(RBI)) %>% 
  mutate(RBI_mean = RBI / atbat) 

dat_rbi_all %>% xtable(digits = 4) %>% print("html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Wed Jun  4 22:15:23 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> runner </TH> <TH> OUTS_CT </TH> <TH> atbat </TH> <TH> RBI </TH> <TH> RBI_mean </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD align="right">     0 </TD> <TD align="right">     0 </TD> <TD align="right"> 45601 </TD> <TD align="right">  1347 </TD> <TD align="right"> 0.0295 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD align="right">     0 </TD> <TD align="right">     1 </TD> <TD align="right"> 32877 </TD> <TD align="right">   831 </TD> <TD align="right"> 0.0253 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD align="right">     0 </TD> <TD align="right">     2 </TD> <TD align="right"> 26180 </TD> <TD align="right">   633 </TD> <TD align="right"> 0.0242 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD align="right">     1 </TD> <TD align="right">     0 </TD> <TD align="right"> 10996 </TD> <TD align="right">   695 </TD> <TD align="right"> 0.0632 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD align="right">     1 </TD> <TD align="right">     1 </TD> <TD align="right"> 13071 </TD> <TD align="right">   831 </TD> <TD align="right"> 0.0636 </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD align="right">     1 </TD> <TD align="right">     2 </TD> <TD align="right"> 13385 </TD> <TD align="right">   963 </TD> <TD align="right"> 0.0719 </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD align="right">    10 </TD> <TD align="right">     0 </TD> <TD align="right">  3357 </TD> <TD align="right">   443 </TD> <TD align="right"> 0.1320 </TD> </TR>
  <TR> <TD align="right"> 8 </TD> <TD align="right">    10 </TD> <TD align="right">     1 </TD> <TD align="right">  5653 </TD> <TD align="right">   832 </TD> <TD align="right"> 0.1472 </TD> </TR>
  <TR> <TD align="right"> 9 </TD> <TD align="right">    10 </TD> <TD align="right">     2 </TD> <TD align="right">  7307 </TD> <TD align="right">  1223 </TD> <TD align="right"> 0.1674 </TD> </TR>
  <TR> <TD align="right"> 10 </TD> <TD align="right">    11 </TD> <TD align="right">     0 </TD> <TD align="right">  2584 </TD> <TD align="right">   503 </TD> <TD align="right"> 0.1947 </TD> </TR>
  <TR> <TD align="right"> 11 </TD> <TD align="right">    11 </TD> <TD align="right">     1 </TD> <TD align="right">  4609 </TD> <TD align="right">   996 </TD> <TD align="right"> 0.2161 </TD> </TR>
  <TR> <TD align="right"> 12 </TD> <TD align="right">    11 </TD> <TD align="right">     2 </TD> <TD align="right">  5753 </TD> <TD align="right">  1343 </TD> <TD align="right"> 0.2334 </TD> </TR>
  <TR> <TD align="right"> 13 </TD> <TD align="right">   100 </TD> <TD align="right">     0 </TD> <TD align="right">   476 </TD> <TD align="right">   211 </TD> <TD align="right"> 0.4433 </TD> </TR>
  <TR> <TD align="right"> 14 </TD> <TD align="right">   100 </TD> <TD align="right">     1 </TD> <TD align="right">  1833 </TD> <TD align="right">   874 </TD> <TD align="right"> 0.4768 </TD> </TR>
  <TR> <TD align="right"> 15 </TD> <TD align="right">   100 </TD> <TD align="right">     2 </TD> <TD align="right">  2948 </TD> <TD align="right">   613 </TD> <TD align="right"> 0.2079 </TD> </TR>
  <TR> <TD align="right"> 16 </TD> <TD align="right">   101 </TD> <TD align="right">     0 </TD> <TD align="right">   977 </TD> <TD align="right">   477 </TD> <TD align="right"> 0.4882 </TD> </TR>
  <TR> <TD align="right"> 17 </TD> <TD align="right">   101 </TD> <TD align="right">     1 </TD> <TD align="right">  2088 </TD> <TD align="right">  1059 </TD> <TD align="right"> 0.5072 </TD> </TR>
  <TR> <TD align="right"> 18 </TD> <TD align="right">   101 </TD> <TD align="right">     2 </TD> <TD align="right">  2946 </TD> <TD align="right">   786 </TD> <TD align="right"> 0.2668 </TD> </TR>
  <TR> <TD align="right"> 19 </TD> <TD align="right">   110 </TD> <TD align="right">     0 </TD> <TD align="right">   601 </TD> <TD align="right">   399 </TD> <TD align="right"> 0.6639 </TD> </TR>
  <TR> <TD align="right"> 20 </TD> <TD align="right">   110 </TD> <TD align="right">     1 </TD> <TD align="right">  1525 </TD> <TD align="right">   847 </TD> <TD align="right"> 0.5554 </TD> </TR>
  <TR> <TD align="right"> 21 </TD> <TD align="right">   110 </TD> <TD align="right">     2 </TD> <TD align="right">  1881 </TD> <TD align="right">   609 </TD> <TD align="right"> 0.3238 </TD> </TR>
  <TR> <TD align="right"> 22 </TD> <TD align="right">   111 </TD> <TD align="right">     0 </TD> <TD align="right">   630 </TD> <TD align="right">   446 </TD> <TD align="right"> 0.7079 </TD> </TR>
  <TR> <TD align="right"> 23 </TD> <TD align="right">   111 </TD> <TD align="right">     1 </TD> <TD align="right">  1621 </TD> <TD align="right">  1242 </TD> <TD align="right"> 0.7662 </TD> </TR>
  <TR> <TD align="right"> 24 </TD> <TD align="right">   111 </TD> <TD align="right">     2 </TD> <TD align="right">  2008 </TD> <TD align="right">  1068 </TD> <TD align="right"> 0.5319 </TD> </TR>
   </TABLE>

なるほど. ためしに満塁だけ注目.

```r
dat_rbi_all %>%
  dplyr::filter(runner == 111) %>%
  xtable(digits = 4) %>% print("html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Wed Jun  4 22:15:23 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> runner </TH> <TH> OUTS_CT </TH> <TH> atbat </TH> <TH> RBI </TH> <TH> RBI_mean </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD align="right">   111 </TD> <TD align="right">     0 </TD> <TD align="right">   630 </TD> <TD align="right">   446 </TD> <TD align="right"> 0.7079 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD align="right">   111 </TD> <TD align="right">     1 </TD> <TD align="right">  1621 </TD> <TD align="right">  1242 </TD> <TD align="right"> 0.7662 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD align="right">   111 </TD> <TD align="right">     2 </TD> <TD align="right">  2008 </TD> <TD align="right">  1068 </TD> <TD align="right"> 0.5319 </TD> </TR>
   </TABLE>

0アウト満塁だと, 1打席で0.708点. 
1アウト満塁だと, 1打席で0.766点ですか. 
0アウト満塁よりも, 1アウト満塁のほうが, 平均打点が高いみたいです.

ちょっと感覚と合いません. 
1アウトなら, ゲッツーで終わっちゃいますもんね. 
0アウトなら, ゲッツーの間に1点は入ります. 

つづきます. 
