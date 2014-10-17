#!/bin/zsh

dir=$(dirname $0)
year=13
for year in 09 10 11 12 13 
do
  [ -d "$dir/player_data_$year" ] || mkdir $dir/player_data_$year
  playerDataDir=$dir/player_data_$year

  #for team in g t
  for team in g t d s yb c e l m h bs f 
  do
    curl baseball-data.com/$year/player/$team/ > $playerDataDir/$team.html

    cat  $playerDataDir/$team".html" |
    grep "text-align:left" |
    sed 's/<[^>]*>//g'|
    sed 's/　/ /g' > $playerDataDir/player_name.txt.tmp

    cat  $playerDataDir/$team".html" |
    grep -E "[0-9]{4}/[0-9]{2}/[0-9]{2}" |
    sed 's/<[^>]*>//g' > $playerDataDir/player_birthday.txt.tmp

    cat  $playerDataDir/$team".html" |
    grep "万円" |
    sed 's/万円//g' | 
    sed 's/,//g' | 
    sed 's/<[^>]*>//g' > $playerDataDir/player_salaty.txt.tmp

    ## career
    cat  $playerDataDir/$team".html" |
    grep "text-align:right" | 
    grep "年" | 
    sed 's/<[^>]*>//g'|
    sed 's/年//g' > $playerDataDir/player_career.txt.tmp


    ls $playerDataDir | 
    grep "tmp" | 
    grep -v "player_name" | 
    sed "s;^;$playerDataDir/;" |
    xargs -J % paste -d "," "$playerDataDir/player_name.txt.tmp" % > "$playerDataDir/$team.playerdata.txt"

    rm $playerDataDir/*.tmp
  done
done



