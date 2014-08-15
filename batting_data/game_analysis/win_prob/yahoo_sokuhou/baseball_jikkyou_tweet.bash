#!/bin/bash

set -e
./baseball_jikkyou.bash
filehame -lLABEL ~/Dropbox/tweet.R out.txt > ./tweet.R
R -f tweet.R
