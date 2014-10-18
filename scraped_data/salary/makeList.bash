#!/bin/zsh

for file in `cat ./teams.txt`
do
  cat "$file" |  
  grep -E "[0-9]{4}年" | 
  awk -F"\"" 'NF>1{print $2}' | 
  head -n 35  > $file".list"
done
