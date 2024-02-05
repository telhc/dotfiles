#!/bin/bash

CSV="$HOME/ObsidianHome/To/Time.md"
CSVOUT="$HOME/ObsidianHome/To/TimeCalculated.md"
numFields=$(awk -F, 'NR==2 { print NF }' $CSV)

datediff() {
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    echo $(( (d1 - d2) / 60 )) minutes
}

if [ $numFields == 2 ];
then
  startTime=$(awk -F, 'NR==2 { print $1 }' $CSV)
  echo $startTime
elif [ $numFields == 3 ];
then
  startTime=$(awk -F, 'NR==2 { print $1 }' $CSV)
  echo $(datediff "now" "$startTime")
fi

awk 'NR==1 {print $0}' $CSV > $CSVOUT
awk -F, 'function datediff(start, end) { return (mktime(gensub(/[-:]/,"  ","g",end))-mktime(gensub(/[-:]/,"  ","g",start)))/60 } NR > 1 { print $1 FS $2 FS $3 FS datediff($1, $3) }' $CSV >> $CSVOUT
