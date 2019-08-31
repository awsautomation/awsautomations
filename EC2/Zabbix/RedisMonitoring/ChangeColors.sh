#!/bin/bash
#IFS=$'\n'
hexchars="0123456789ABCDEF"

CHANGECOLORS="Items/tmp/AddRedisGraph.json"
while read -r line
do
for word in $line
do
randcolor=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done )
sed -i s/\$RANDCOLOR/$randcolor/ Items/tmp/AddRedisGraph.json
done
done < "$CHANGECOLORS"
