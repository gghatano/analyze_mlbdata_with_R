#!/bin/bash

out=$(cat out.txt)

cat test.R | 
sed "s/hoge/$out/"
