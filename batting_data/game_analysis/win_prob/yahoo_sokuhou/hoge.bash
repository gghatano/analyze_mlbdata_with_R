#!/bin/bash
dir=$(dirname $0)
situation=$(cat $dir/out3.txt | awk -F";" '{print $1,$2,$3,$4, $7-$6}' | sed 's/ /,/g')
echo $situation
cat $dir/win_prob.csv | grep -E "^$situation," | 
awk -F"," '{print $10, $9}'

