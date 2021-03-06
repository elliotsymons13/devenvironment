#!/bin/bash

MON="eDP-1"

CurrBrightness=$( xrandr --verbose |  grep ^"$MON" -A5 | tail -n1 | sed 's/[^(0-9|.)]*//g' ) 
echo "Current brightness: " $CurrBrightness 
NewBrightness=$( echo "$CurrBrightness + 0.1" | bc )

if (( $(echo "$NewBrightness > 1.0" | bc -l) )) ; then
    echo "Max brightness"
    exit
fi

echo "New brightness: " $NewBrightness
xrandr --output $MON --brightness $NewBrightness