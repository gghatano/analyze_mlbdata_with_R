#!/bin/bash

dir=$(dirname $0)
mkdir $dir"/players_data_2014"
for team in g t d s yb c e l m h bs f 
#for team in g t 
do
  curl "baseball-data.com/player/$team/" > $dir/"players_data_2014/"$team".html"

  ## players_name
  cat $dir/players_data_2014/"$team".html |
  grep "text-align:left" |
  sed 's/<[^>]*>//g'|
  sed 's/　/ /g' > $dir"/players_data_2014/"$team".player_name.txt.tmp"

  ## birthday
  cat $dir/players_data_2014/"$team".html |
  grep -E "[0-9]{4}/[0-9]{2}/[0-9]{2}" |
  sed 's/<[^>]*>//g' > $dir"/players_data_2014/"$team".player_birthday.txt.tmp"

  ## salary
  cat $dir/players_data_2014/"$team".html |
  grep "万円" |
  sed 's/<[^>]*>//g'|
  sed 's/万円//g' | 
  sed 's/,//g' > $dir"/players_data_2014/"$team".player_salary.txt.tmp"

  ## career
  cat $dir/players_data_2014/"$team".html |
  grep "text-align:right" | 
  grep "年" | 
  sed 's/<[^>]*>//g'|
  sed 's/年//g' > $dir"/players_data_2014/"$team".player_career.txt.tmp"

  ## ここがダメ
  ls $dir/players_data_2014/ | 
  grep -E "$team" | 
  grep "tmp" | 
  grep -v "player_name" | 
  sed "s;^;$dir/players_data_2014/;" |
  xargs -J % paste -d "," $dir/players_data_2014/"$team".player_name.txt.tmp % > $dir"/players_data_2014/"$team".playerdata.txt"

  rm $dir/players_data_2014/*.tmp
  # rm $dir/players_data_2014/*.html
done

