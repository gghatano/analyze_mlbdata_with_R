#!/bin/bash
dir=$(dirname $0)
set -e
echo $(date +%Y%m%d%H%M%S)
$dir/baseball_jikkyou.bash
echo "jikkyou OK" >> $HOME/Dropbox/cron.log.txt
$(which filehame) -lLABEL $HOME/Dropbox/tweet.R $dir/out.txt > $dir/tweet.R
echo "filehame OK" >> $HOME/Dropbox/cron.log.txt
$(which R) -q --slave --vanilla -f $dir/tweet.R
echo "tweet OK" >> $HOME/Dropbox/cron.log.txt
