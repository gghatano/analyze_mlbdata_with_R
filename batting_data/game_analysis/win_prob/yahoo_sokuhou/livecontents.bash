#!/bin/bash
file=$1
start=$(cat $file | grep -n 'id="livecontent"' | awk -F: '{print $1}')
end=$(cat $file | grep -n "<!--popup-->" | awk -F: '{print $1}')

echo $start
echo $end

livecontent=$(sed -n "$start, ${end}p" $file)

first=cat $file | grep "1塁"
#second=echo $livecontent | grep 2塁
#third=echo $livecontent | grep 3塁

# echo $first:$second:$third
echo $first
