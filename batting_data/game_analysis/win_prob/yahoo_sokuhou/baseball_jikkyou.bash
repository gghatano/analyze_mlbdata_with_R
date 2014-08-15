#!/bin/bash

### URLを生成
### 日付 + 6 + 試合番号(1から4)というルールらしい
#gameId=$(date +%Y%m%d)6
### とりあえず全部チェック
#for game in `seq 1 4` 
#do
#  url="http://baseball.yahoo.co.jp/hsb_summer/game/"$gameId$game"/score/"
#  html=$(curl $url)
#  ## 速報中かどうかチェック
#  sokuhouFlag=$(echo $html | grep "速報中")
#  [ "$sokuhouFlag" = "" ] && break
#  htmlFile=$html 
#done
#
#echo $htmlFile
#
#exit 1
#
## ランナー状況取得
first=$(cat $1 | grep "1塁")
second=$(cat $1 | grep "2塁")
third=$(cat $1 | grep "3塁")
[ "$first" = "" ] || first=1
[ "$second" = "" ] || second=2
[ "$third" = "" ] || third=3

baseSituation="$first$second${third}塁"

# アウトカウント
out=$(cat $1 | grep -A1 'class="o"' | tail -n 1 | 
      sed 's/<[^>]*>//g' | numchar | 
      sed 's/[^;]//g' | 
      xargs echo -n | wc -m) 

# チーム名がほしい
teamScore=$(cat $1 | grep -A4 'class="score"' | tail -n 2 |
        sed 's/<[^>]*>//g') 

team=$(echo $teamScore | sed 's/[0-9]/ /g'| cat - )
# 先攻チーム
team1=$(echo $team | awk '{print $1}')
# 後攻チーム
team2=$(echo $team | awk '{print $2}')

# スコア
score=$(echo $teamScore |
sed 's/[^0-9]/ /g'| cat - )
# 先攻のスコア
score1=$(echo $score | awk '{print $1}')
# 後攻のスコア
score2=$(echo $score | awk '{print $2}')

## イニング
# 後攻のスコア
ining=$(cat $1 | 
        grep -A1 'class="live"' | 
        tail -n 1 | 
        sed 's/<[^>]*>//g')
## 試合状況 内容
echo $ining $out"アウト" "ランナー "$baseSituation
echo "$team1 $score1-$score2 $team2"


