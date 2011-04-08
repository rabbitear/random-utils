#!/bin/sh
rotation=`xrandr -q | grep "Current rotation" | cut -d"-" -f2`
if [ $rotation = "normal" ] ;
then
   xrandr -o left
else
   xrandr -o normal
fi

