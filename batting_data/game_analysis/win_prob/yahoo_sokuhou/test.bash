#!/bin/bash
set -e
num=$(cat ~/kousien_jikkyou_template.R | grep "LABEL")
num2=$(cat ~/kousien_jikkyou.R | grep "LABEL")
echo $?
echo $num
