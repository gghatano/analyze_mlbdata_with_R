#!/bin/bash
dir=$(dirname $0)

echo $(date +%Y%m%d%H%M%S)
## 実況
$dir/hoge.bash

echo "------------------------------------------"
echo "------------------------------------------"
echo "------------------------------------------"
echo "jikkyou OK" >> $HOME/Dropbox/cron.log.txt
echo "jikkyou OK" 

## 勝率計算
### situationに合致する勝率をwin_prob.csvから探す
for gameNumber in `seq 1 6`
do
  cat $dir/game_situation_$gameNumber".txt" | xargs echo
  situation=$(cat $dir/game_situation_$gameNumber".txt" |
  xargs echo -n | 
  sed -e 's/無し/0/' -e 's/表/ 0/' -e 's/裏/ 1/' -e 's/ /;/g' -e 's/-/;/' -e 's/[^0-9;]//g')

  echo "試合データ" $situation

  ### 点差の修正 10点差以上は10点差です. 
  scoreDiff=$(echo $situation | awk -F ";" '{print $8-$7}')
  [ $scoreDiff -lt -10  ] && scoreDiff=-10
  [ $scoreDiff -gt 10  ] && scoreDiff=10
  echo "modify_ok"

  ## 試合状況から勝率を探します
  situation=$(echo $situation | awk -F";" '{print $1, $2, $3, $5}'| sed 's/ /,/g')
  echo "試合状況:"$situation
  outCount=$(echo $situation | awk '{print $3}')
  [ "$outcount" = 3 ] && break
  sleep 3
  winProb=$(cat $dir/win_prob.csv | grep -E "^$situation,$scoreDiff,")
  echo "勝利確率:" $winProb
  winProb1=$(echo $winProb | awk -F "," '{print $10}')
  winProb2=$(echo $winProb | awk -F "," '{print $9}')
  [ "$winProb1" = "" ] && break
  [ "$winProb2" = "" ] && break

  echo "win_prob の計算 OK"

  ## チーム名の取得
  team1=$(cat $dir/game_situation_$gameNumber".txt" | tail -n 1 | awk '{print $5'}) 
  team2=$(cat $dir/game_situation_$gameNumber".txt" | tail -n 1 | awk '{print $7}') 

  ## ツイート用テキストファイルを生成
  cat $dir/game_situation_$gameNumber".txt" > $dir/tweet.$gameNumber".txt"
  echo "" >> $dir/tweet.$gameNumber".txt"
  echo ${team1}の勝率: $winProb1"%" >> $dir/tweet.$gameNumber".txt"
  echo ${team2}の勝率: $winProb2"%" >> $dir/tweet.$gameNumber".txt"

  cat $dir/tweet.$gameNumber".txt"
  ## ツイートしてくれるRスクリプトを生成
  $(which filehame) -lLABEL $HOME/giants_sokuhou_template.R $dir/tweet.$gameNumber".txt" >  ~/giants_sokuhou.R
  echo "filehame OK" >> $HOME/Dropbox/cron.log.txt

  label=$(cat ~/giants_sokuhou.R | grep  "LABEL")
  [ "$label" = "" ] || break

  ## ツイートします
  $(which R) -q --slave --vanilla -f ~/giants_sokuhou.R
  echo "tweet OK" >> $HOME/Dropbox/cron.log.txt
done

