#!/bin/bash
dir=$(dirname $0)

## 1つでもエラーが出たら終了
set -e
echo $(date +%Y%m%d%H%M%S)
## 実況
$dir/baseball_jikkyou.bash
echo "jikkyou OK" >> $HOME/Dropbox/cron.log.txt

## 勝率計算
### situationに合致する勝率をwin_prob.csvから探す
situation=$(cat $dir/out.txt | 
xargs echo -n | 
sed -e 's/無し/0/' -e 's/表/ 0/' -e 's/裏/ 1/' -e 's/ /;/g' -e 's/-/;/' -e 's/[^0-9;]//g')

echo $situation 

### 点差の修正
scoreDiff=$(echo $situation | awk -F ";" '{print $7-$6}')
echo $scoreDiff
[ $scoreDiff -lt -10  ] && scoreDiff=-10
[ $scoreDiff -gt 10  ] && scoreDiff=10
echo $scoreDiff

situation=$(echo $situation | awk -F";" '{print $1, $2, $3, $4}'| sed 's/ /,/g')
echo $situation
echo $situation,$scoreDiff
winProb=$(cat $dir/win_prob.csv | grep -E "^$situation,$scoreDiff,")
echo $winProb
winProb1=$(echo $winProb|awk -F "," '{print $10}')
winProb2=$(echo $winProb|awk -F "," '{print $9}')
[ "$winProb1" = "" ] && exit 1
[ "$winProb2" = "" ] && exit 1

## チーム名の取得
team1=$(cat $dir/out.txt | tail -n 1 | awk '{print $1}') 
team2=$(cat $dir/out.txt | tail -n 1 | awk '{print $3}') 

## ツイート用テキストファイルを生成
cat $dir/out.txt > $dir/tweet.txt
echo "" >> $dir/tweet.txt
echo ${team1}の勝率: $winProb1"%" >> $dir/tweet.txt
echo ${team2}の勝率: $winProb2"%" >> $dir/tweet.txt

## ツイートスクリプト生成
$(which filehame) -lLABEL $HOME/kousien_jikkyou_template.R $dir/tweet.txt > ~/kousien_jikkyou.R

echo "filehame OK" >> $HOME/Dropbox/cron.log.txt

## ツイート
$(which R) -q --slave --vanilla -f ~/kousien_jikkyou.R
echo "tweet OK" >> $HOME/Dropbox/cron.log.txt
