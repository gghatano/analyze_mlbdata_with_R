#!/bin/bash
dir=$(dirname $0)

## 1つでもエラーが出たら終了
set -e
echo $(date +%Y%m%d%H%M%S)
## 実況
$dir/baseball_jikkyou.bash
echo "jikkyou OK" >> $HOME/Dropbox/cron.log.txt
## ツイートスクリプト生成
$(which filehame) -lLABEL $HOME/kousien_jikkyou_template.R $dir/out.txt > ~/kousien_jikkyou.R
echo "filehame OK" >> $HOME/Dropbox/cron.log.txt
## ツイート
$(which R) -q --slave --vanilla -f ~/kousien_jikkyou.R
echo "tweet OK" >> $HOME/Dropbox/cron.log.txt
