#!/bin/bash

cat ./dat2013_04.csv | 
mcut f=GAME_ID,HOME_SCORE_CT,AWAY_SCORE_CT |
mstats k=GAME_ID f=HOME_SCORE_CT:HOME,AWAY_SCORE_CT:AWAY c=max | 
mcal c='max(${HOME},${AWAY})' a=SCORE_WIN |
mcal c='min(${HOME},${AWAY})' a=SCORE_LOSE | 
mcut f=SCORE_WIN,SCORE_LOSE | 
mcount k=SCORE_WIN,SCORE_LOSE a=GAME | 
msortf f=GAME%nr 


