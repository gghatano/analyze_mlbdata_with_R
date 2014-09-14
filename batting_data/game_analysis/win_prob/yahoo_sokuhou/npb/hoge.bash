#!/bin/bash

dir=$(dirname $0)

date=$(date +%Y%m%d)

for gameNumber in `seq 1 6`
do
 gameUrl="http://live.baseball.yahoo.co.jp/npb/game/"$date"0"$gameNumber"/score"
 htmlFile="score_game_"$gameNumber".html"
 curl $gameUrl > $dir/$htmlFile

 htmlContents=$(cat $dir/$htmlFile)

 sokuhouFlag=$(echo "$htmlContents" | grep "<p>速報中</p>")
 [ "$sokuhouFlag" = "" ] && break
 echo "速報します"

  ## 塁状況の変化途中かどうかを確認
  ## ヒットなどの結果が出ている場合, 試合状況がうまく取れないので.
  resultData=$(echo "$htmlContents" | 
               grep -A5 'id="result"' | 
               grep "class='red'")
  [ "$resultData" = "" ] || break
  echo "勝率を計算できます"


  ## ランナー状況取得
  fieldSituation=$(echo "$htmlContents" | 
                    grep -A15 "<!--field-->" )
                    first=$(echo $fieldSituation | grep "1塁")
                    second=$(echo $fieldSituation | grep "2塁")
                    third=$(echo $fieldSituation | grep "3塁")
  [ "$first" = "" ] || first=1
  [ "$second" = "" ] || second=2
  [ "$third" = "" ] || third=3

  baseSituation="$first$second${third}塁"
  [ "$baseSituation" = "塁" ] && baseSituation="無し"

  echo "一塁"  $first
  echo "二塁"  $second
  echo "三塁"  $third
  echo "全体"  $baseSituation

  # アウトカウント
  out=$(echo "$htmlContents" | grep -A1 'class="o"' | tail -n 1 | 
  sed 's/[<>]/;/g' |
        awk -F";" '{print $3}' |
        numchar | 
        sed 's/[^;]//g' | 
        xargs echo -n | wc -m | 
        sed 's/[^0-9]//g')

  ## 3アウトか0アウトかは, 現状ではこうしないと分からん
  threeOutFlag=$(echo "$htmlContents" | grep "3アウト")
  # [ "$threeOutFlag" = "" ] || break

  # チーム名とスコア
  teamScore=$(echo "$htmlContents" | 
              grep -A8 'class="live"' | 
              tail -n 2 |
              sed 's/<[^>]*>//g') 

  team=$(echo $teamScore | sed 's/[0-9]/ /g'| cat - )
  # 先攻チーム
  team1=$(echo $team | awk '{print $1}')
  # 後攻チーム
  team2=$(echo $team | awk '{print $2}')
  [ "$team1" = "" ] && break
  [ "$team2" = "" ] && break
  # スコア
  score=$(echo $teamScore | sed 's/[^0-9]/ /g'| cat - )
  # 先攻のスコア
  score1=$(echo $score | awk '{print $1}')
  # 後攻のスコア
  score2=$(echo $score | awk '{print $2}')
  [ "$score1" = "" ] && break
  [ "$score2" = "" ] && break
  echo "スコアとれました"

  ## イニング
  # 後攻のスコア
  ining=$(echo "$htmlContents" | 
          grep -A1 'class="live"' | 
          tail -n 1 | 
          sed 's/<[^>]*>//g')
  ## 試合状況 内容
  echo $ining $out"アウト" "ランナー "$baseSituation
  echo "$team1 $score1-$score2 $team2"

  game_situation=$(echo $ining $out"アウト ランナー "$baseSituation $team1 $score1-$score2 $team2)
  echo $game_situation > $dir/game_situation_$gameNumber$".txt"
done 

