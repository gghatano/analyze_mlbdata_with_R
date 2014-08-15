#!/bin/bash

url="http://live.baseball.yahoo.co.jp/hsb_summer/game/2014081561/score"

curl $url | grep "速報中"
