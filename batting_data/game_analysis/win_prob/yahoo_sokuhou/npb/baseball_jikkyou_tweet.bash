#!/bin/bash
dir=$(dirname $0)
set -e
echo $(date +%Y%m%d%H%M%S)
$dir/baseball_jikkyou.bash
echo "jikkyou OK"
$(which filehame) -lLABEL ~/giants_sokuhou_template.R $dir/out.txt > ~/giants_sokuhou.R
echo "filehame OK"
$(which R) -q --slave --vanilla -f ~/giants_sokuhou.R
echo "tweet OK"
