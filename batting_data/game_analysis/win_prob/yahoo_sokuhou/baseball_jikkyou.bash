#!/bin/bash
dir=$(dirname $0)

## URLを生成
## 試合速報サイトは, 
## 日付 + 6 + 試合番号(1から4)というルールらしい

gameId=$(date +%Y%m%d)6
for game in `seq 1 4` 
do
  url="http://live.baseball.yahoo.co.jp/hsb_summer/game/"$gameId$game"/score/"
  curl $url > $dir/tmp.html
  ## 速報中かどうかチェック
  sokuhouFlag=$(cat $dir/tmp.html | grep "速報中")
  [ "$sokuhouFlag" = "" ] || break
done

## 速報中の試合がなければexit
[ "$sokuhouFlag" = "" ] && exit 1

## 塁状況の変化途中かどうかを確認
## ヒットなどの結果が出ている場合, 試合状況がうまく取れないから
resultData=$(cat $dir/tmp.html | 
             grep -A5 'id="result"' | 
             grep "class='red'")
[ "$resultData" = "" ] || exit 1

## ランナー状況取得
fieldSituation=$(cat $dir/tmp.html | 
                  grep -A15 "<!--field-->" )
                  first=$(echo $fieldSituation | grep "1塁")
                  second=$(echo $fieldSituation | grep "2塁")
                  third=$(echo $fieldSituation | grep "3塁")
[ "$first" = "" ] || first=1
[ "$second" = "" ] || second=2
[ "$third" = "" ] || third=3

baseSituation="$first$second${third}塁"
[ "$baseSituation" = "塁" ] && baseSituation="無し"

# アウトカウント
cat $dir/tmp.html | grep -A1 'class="o"' | xargs echo 
out=$(cat $dir/tmp.html | grep -A1 'class="o"' | tail -n 1 | 
sed 's/[<>]/;/g' |
      awk -F";" '{print $3}' |
      numchar | 
      sed 's/[^;]//g' | 
      xargs echo -n | wc -m | 
      sed 's/[^0-9]//g')

## ここを直す

# チーム名とスコア
teamScore=$(cat $dir/tmp.html | 
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

