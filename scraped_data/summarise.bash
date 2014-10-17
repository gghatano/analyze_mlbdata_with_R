#!/bin/zsh

[ -e player.txt ] && rm player.txt

for dir in `ls | grep player_data`
do
  cd $dir
  for files in `ls | grep playerdata`
  do
    cat $files | sed "s/^/$dir, $files,/" >> ../player.txt
  done
  cd ../
done

## 整理

cat player.txt | 
sed "s/player_data_//" | 
sed "s/\.playerdata\.txt//" |
sed "s/, /,/" > player.txt.tmp

mv player.txt.tmp player.txt
