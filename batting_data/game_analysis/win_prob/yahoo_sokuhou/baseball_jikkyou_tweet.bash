#!/bin/bash
dir=$(dirname $0)
set -e
echo $(date +%Y%m%d%H%M%S)
$dir/baseball_jikkyou.bash
echo "jikkyou OK"
filehame -lLABEL /usr/home/Dropbox/tweet.R $dir/out.txt > $dir/tweet.R
echo "filehame OK"
$(which R) -q --slave --vanilla -f $dir/tweet.R
echo "tweet OK"
