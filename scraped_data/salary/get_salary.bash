#!/bin/zsh
set -e 

htmls=$(cat giants.txt|grep -E "[0-9]{4}蟷ｴ" | awk -F"\"" 'NF>1{print $2}')

## 13年, 14年はリンクの構造が異なるので, 気をつける
# html="http://www.monespo.com/2014/01/giants-salary-12.html"

# for listFile in `ls | grep "marines.txt.list"`
for listFile in `ls | grep "txt.list"`
do
  for html in `cat $listFile | head -n 2`
  do
    curl "$html" > test.txt
    year=$(echo $html | 
    awk -F"(/|-)" '{print $4}' | 
    cut -c 3-4)

    team=$(echo $html | 
    awk -F"(/|-)" '{print $6}')

    teamYear=$(echo $team $year)

    echo $team
    echo $year

    cat test.txt | 
    iconv -t UTF8 |
    grep "12288" | 
    sed 's/<[^>]*>/ /g' | 
    sed 's/&......./ /g' | 
    awk -v teamYear="$teamYear" '(NF==3){print teamYear, $0}' > "$team"-salary-"$year".txt
  done

  for html in `cat $listFile | tail +3`
  do
    curl "$html" > test.txt
    fileName=$(echo $html | 
    cut -d"/" -f 6 | 
    xargs -J % basename % .html)

    teamYear=$(echo $fileName | 
    awk -F "-" '{print $(NF-2), $NF}') 

    cat test.txt | 
    iconv -t UTF8 |
    grep "12288" | 
    sed 's/<[^>]*>/ /g' | 
    sed 's/&......./ /g' | 
    awk -v teamYear="$teamYear" '(NF==3){print teamYear, $0}' > "$fileName".txt
  done
done
