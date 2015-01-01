野球のスコアと試合数
====

野球のスコア別に試合数を集計して, ありがちな試合を調べます. 

Rで集計した結果が[こちら](http://gg-hogehoge.hatenablog.com/entry/2014/04/24/223825)

## nysolで集計

nysolで書いてみます. 

80年分のメジャーリーグ全打席結果データ(4.3GB)をなんやかんやします. 
```{bash}
cat ./batting_data.csv | 
mcut f=GAME_ID,HOME_SCORE_CT,AWAY_SCORE_CT |
mstats k=GAME_ID f=HOME_SCORE_CT:HOME,AWAY_SCORE_CT:AWAY c=max | 
mcal c='max(${HOME},${AWAY})' a=SCORE_WIN |
mcal c='min(${HOME},${AWAY})' a=SCORE_LOSE | 
mcut f=SCORE_WIN,SCORE_LOSE | 
mcount k=SCORE_WIN,SCORE_LOSE a=GAME | 
msortf f=GAME%nr 
```
## 集計結果

上位５パターンです.
```{bash}
SCORE_WIN,SCORE_LOSE,GAME%0nr
3,2,5964
4,3,5575
2,1,4951
4,2,4880
3,1,4464
```
3-2が多いですね. 

集計は12秒で終わりました. 凄え. 


