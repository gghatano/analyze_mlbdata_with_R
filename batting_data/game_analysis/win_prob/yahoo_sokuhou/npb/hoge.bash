#!/bin/bash

cat index.html | 
grep -A4 -B4 'title="巨人"><div class' | 
grep "npb/game/" | 
sed 's;.*\(npb/game/[0-9]*\).*;\1;'
