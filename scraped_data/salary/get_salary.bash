#!/bin/zsh
set -e 

htmls=$(cat giants.txt|grep -E "[0-9]{4}蟷ｴ" | awk -F"\"" 'NF>1{print $2}')

## 13年, 14年はリンクの構造が異なるので, 気をつける
# html="http://www.monespo.com/2014/01/giants-salary-12.html"

for listFile in `ls | grep "txt.list"`
do
  for html in `cat $listFile | head -n 2`
  do
    curl "$html" > test.txt
    fileName=$(echo $html | 
    cut -d"/" -f 6 | 
    xargs -J % basename % .html)

    team=$(echo $fileName | 
    awk -F "-" '{print $1}') 

    year=$(echo $html | 
    cut -d"/" -f 4)

    teamYear=$(echo $team $year)
    year2=$(echo $year | cut -c 3-4)

    cat test.txt | 
    iconv -t UTF8 |
    grep "12288" | 
    sed 's/<[^>]*>/ /g' | 
    sed 's/&......./ /g' | 
    awk -v teamYear="$teamYear" '(NF==3){print teamYear, $0}' > "$team"-salary-"$year2".txt
  done

#  for html in `cat $listFile | tail +3`
#  do
#    curl "$html" > test.txt
#    fileName=$(echo $html | 
#    cut -d"/" -f 6 | 
#    xargs -J % basename % .html)
#
#    teamYear=$(echo $fileName | 
#    awk -F "-" '{print $1, $3}') 
#
#    cat test.txt | 
#    iconv -t UTF8 |
#    grep "12288" | 
#    sed 's/<[^>]*>/ /g' | 
#    sed 's/&......./ /g' | 
#    awk -v teamYear="$teamYear" '(NF==3){print teamYear, $0}' > "$fileName".txt
#  done
done
