#!/bin/bash

ARTIST=`mpc --format "%artist%" | head -n 1`
TITLE=`mpc --format "%title%" | head -n 1`

echo $ARTIST >ttmp
iconv -f utf8 -t gbk ttmp >ttmp1
ARTIST_gbk=`cat ttmp1`
echo $ARTIST $ARTIST_gbk
echo $TITLE >ttmp
iconv -f utf8 -t gbk ttmp >ttmp1
TITLE_gbk=`ca ttmp1`
rm ttmp ttmp-1

URL="http://mp3.baidu.com/m?tn=baidump3lyricp&word=$ARTIST_gbk+$TITLE_gbk&ct=150994944&lm=-1&rn=1&pn=0"
w3m "$URL" 
