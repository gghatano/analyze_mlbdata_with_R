#!/bin/zsh

htmls=$(cat giants.txt|grep -E "[0-9]{4}蟷ｴ" | awk -F"\"" 'NF>1{print $2}')

# for html in `"$htmls"`

## 13年, 14年はリンクの構造が異なるので, 気をつける
html="http://www.monespo.com/2014/01/giants-salary-12.html"

curl $html | grep "円" | 
grep "円" | awk -F"[<>]" '{print $3, $5}' |
sed 's/&#[0-9]*;//g' |
sed 's/([^)]*)//'
