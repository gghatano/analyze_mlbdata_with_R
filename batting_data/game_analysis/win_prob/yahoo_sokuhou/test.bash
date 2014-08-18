#!/bin/bash

scoreDiff=$(cat test.txt | awk -F "," '{print $7-$6}')
echo $scoreDiff
[ $scoreDiff -lt -10  ] && scoreDiff=-10
[ $scoreDiff -gt -10  ] && scoreDiff=10
echo $scoreDiff

situation=$(cat test.txt | awk -F"," '{print $1, $2, $3, $4}'| sed 's/ /,/g')
echo $situation
echo $situation,$scoreDiff
cat win_prob.csv | grep -E "^$situation,$scoreDiff," | xargs echo
