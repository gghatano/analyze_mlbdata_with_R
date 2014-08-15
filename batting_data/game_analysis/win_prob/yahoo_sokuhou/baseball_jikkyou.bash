#!/bin/bash
## URLを生成
## 試合速報サイトは, 
## 日付 + 6 + 試合番号(1から4)
## というルールらしい
gameId=$(date +%Y%m%d)6
for game in `seq 1 4` 
do
  url="http://live.baseball.yahoo.co.jp/hsb_summer/game/"$gameId$game"/score/"
  curl $url > tmp.html
  ## 速報中かどうかチェック
  sokuhouFlag=$(cat tmp.html | grep "速報中")
  [ "$sokuhouFlag" = "" ] || break
done

## ランナー状況取得
first=$(cat tmp.html | grep "1塁")
second=$(cat tmp.html | grep "2塁")
third=$(cat tmp.html | grep "3塁")
[ "$first" = "" ] || first=1
[ "$second" = "" ] || second=2
[ "$third" = "" ] || third=3

baseSituation="$first$second${third}塁"
[ "$baseSituation" = "塁" ] && baseSituation="無し"

# アウトカウント
cat tmp.html | grep -A1 'class="o"' | xargs echo 
out=$(cat tmp.html | grep -A1 'class="o"' | tail -n 1 | 
sed 's/[<>]/;/g' |
      awk -F";" '{print $3}' |
      numchar | 
      sed 's/[^;]//g' | 
      xargs echo -n | wc -m | 
      sed 's/[^0-9]//g')

# チーム名とスコア
teamScore=$(cat tmp.html | 
            grep -A4 'class="score"' | 
            tail -n 2 |
            sed 's/<[^>]*>//g') 

team=$(echo $teamScore | sed 's/[0-9]/ /g'| cat - )
# 先攻チーム
team1=$(echo $team | awk '{print $1}')
# 後攻チーム
team2=$(echo $team | awk '{print $2}')
[ "$team1" = "" ] && exit 1
[ "$team2" = "" ] && exit 1

# スコア
score=$(echo $teamScore | sed 's/[^0-9]/ /g'| cat - )
# 先攻のスコア
score1=$(echo $score | awk '{print $1}')
# 後攻のスコア
score2=$(echo $score | awk '{print $2}')
[ "$score1" = "" ] && exit 1
[ "$score2" = "" ] && exit 1

## イニング
# 後攻のスコア
ining=$(cat tmp.html | 
        grep -A1 'class="live"' | 
        tail -n 1 | 
        sed 's/<[^>]*>//g')
## 試合状況 内容
echo $ining $out"アウト" "ランナー "$baseSituation
echo "$team1 $score1-$score2 $team2"

cat << FIN > out.txt
$ining ${out}アウト ランナー $baseSituation 
$team1 $score1-$score2 $team2
FIN

rm tmp.html

