#!/usr/bin/env bash
DT1=$2
((DT2=$DT1+10))

if [ "$1" = "-f" ]
then
  bspc desktop -f $DT2
  bspc desktop -f $DT1
elif [ "$1" = "-d" ]
then
  bspc node -d $DT1
fi
