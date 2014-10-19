#!/bin/zsh

dir=$(dirname $0)

for file in `cat $dir/team_link.txt`
do
  curl $file > $(basename "$file" .html)".txt"
done

