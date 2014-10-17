#!/bin/zsh

htmls=$(cat giants.txt|grep -E "[0-9]{4}年" | awk -F"\"" 'NF>1{print $2}')

# for html in `"$htmls"`

## 13�N, 14�N�̓����N�̍\�����قȂ�̂�, �C������
html="http://www.monespo.com/2014/01/giants-salary-12.html"

curl $html | grep "�~" | 
grep "�~" | awk -F"[<>]" '{print $3, $5}' |
sed 's/&#[0-9]*;//g' |
sed 's/([^)]*)//'
