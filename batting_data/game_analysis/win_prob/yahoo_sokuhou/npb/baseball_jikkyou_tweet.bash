#!/bin/bash
dir=$(dirname $0)
set -e
$dir/baseball_jikkyou.bash
filehame -lLABEL ~/Dropbox/tweet.R $dir/out.txt > $dir/tweet.R
$(which R) -q --slave --vanilla -f $dir/tweet.R
