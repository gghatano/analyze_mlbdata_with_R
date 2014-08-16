#!/bin/bash

## URLを生成
## 巨人の試合の一球速報サイトのURLを探す
dir=$(dirname $0)
wget "http://baseball.yahoo.co.jp/npb/schedule/"

giants_url=$(cat $dir/index.html | 
grep -A4 -B4 'title="巨人"><div class' | 
grep "npb/game/" | 
sed 's;.*npb/game/\([0-9]*\).*;\1;')

url="http://live.baseball.yahoo.co.jp/npb/game/$giants_url/score"
rm $dir/index.html

## 一球速報.htmlをダウンロード
curl $url > $dir/tmp.html

## 速報中かどうかチェック
sokuhouFlag=$(cat $dir/tmp.html | grep "<p>速報中</p>")
[ "$sokuhouFlag" = "" ] && exit 1

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
out=$(cat $dir/tmp.html | grep -A1 'class="o"' | tail -n 1 | 
sed 's/[<>]/;/g' |
      awk -F";" '{print $3}' |
      numchar | 
      sed 's/[^;]//g' | 
      xargs echo -n | wc -m | 
      sed 's/[^0-9]//g')

## 3アウトか0アウトかは, 現状ではこうしないと分からん
threeOutFlag=$(cat $dir/tmp.html | grep "3アウト")
if [ "$out" = "3" ]
then 
  [ "$threeOutFlag" = "" ] || exit 1
fi

# チーム名とスコア
teamScore=$(cat $dir/tmp.html | 
            grep -A8 'class="live"' | 
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
ining=$(cat $dir/tmp.html | 
        grep -A1 'class="live"' | 
        tail -n 1 | 
        sed 's/<[^>]*>//g')
## 試合状況 内容
echo $ining $out"アウト" "ランナー "$baseSituation
echo "$team1 $score1-$score2 $team2"

cat << FIN > $dir/out.txt
$ining ${out}アウト ランナー $baseSituation 
$team1 $score1-$score2 $team2
FIN

rm $dir/tmp.html
