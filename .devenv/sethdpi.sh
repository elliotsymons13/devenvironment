#!/bin/bash

resolution_w=$(xdpyinfo | awk '/dimensions/{print $2}' | cut  -d"x" -f1)
threshold_for_hdpi=4000
if [ $resolution_w -ge $threshold_for_hdpi ] ; then
    export GDK_SCALE=2
    export GDK_DPI_SCALE=0.5
    export ELM_SCALE=2
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    xrdb -override ~/.devenv/X192dpi.txt
else
    export GDK_SCALE=1
    export GDK_DPI_SCALE=1
    export ELM_SCALE=1
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    xrdb -override ~/.devenv/X96dpi.txt
fi


