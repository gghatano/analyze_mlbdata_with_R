#!/bin/bash

## このファイルのパス
dir=$(dirname $0)

## URLを生成
## ソフトバンクの試合の一球速報サイトのURLを探します
## まずは, スケジュールのダウンロード
scheduleOfToday=$(date +%Y%m%d)".html"
[ -f "schedule/$scheduleOfToday" ] || curl "http://baseball.yahoo.co.jp/npb/schedule/" > ${dir}/schedule/$scheduleOfToday

## 1日の試合スケジュール.htmlから, ソフトバンク戦URLを探す
team_url=$(cat $dir/schedule/$scheduleOfToday | 
grep -A4 -B4 'title="ソフトバンク"><div class' | 
grep "npb/game/" | 
sed 's;.*npb/game/\([0-9]*\).*;\1;')

## ソフトバンクの試合がなければ終わり
[ "$team_url" = "" ] && exit 1

echo "team_url is OK"

## 一球速報.htmlをダウンロード
url="http://live.baseball.yahoo.co.jp/npb/game/$team_url/score"
curl $url > $dir/tmp.html

echo download_html

## 速報中かどうかチェック
## ここはもうちょっと頑張るべき
sokuhouFlag=$(cat $dir/tmp.html | grep "<p>速報中</p>")
[ "$sokuhouFlag" = "" ] && exit 1

## 塁状況の変化途中かどうかを確認
## ヒットなどの結果が出ている場合, 試合状況がうまく取れないので.
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

echo $first
echo $second
echo $third

echo $baseSituation

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

## 出力
cat << FIN > $dir/out.txt
$ining ${out}アウト ランナー$baseSituation 
$team1 $score1-$score2 $team2
FIN

rm $dir/tmp.html
