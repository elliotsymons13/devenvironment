#!/bin/bash


set_hdpi() {
  echo "Set hdpi mode"
  export GDK_SCALE=2
  export GDK_DPI_SCALE=0.5
  export ELM_SCALE=2
  export QT_AUTO_SCREEN_SCALE_FACTOR=1
  xrdb -override ~/.devenv/X192dpi.txt
}

set_ldpi() {
  echo "Set ldpi mode"
  export GDK_SCALE=1
  export GDK_DPI_SCALE=1
  export ELM_SCALE=1
  export QT_AUTO_SCREEN_SCALE_FACTOR=1
  xrdb -override ~/.devenv/X96dpi.txt
}

# if we don't have a mode file, default to lo
if [[] ! -f "~/.devenv/dpimode" ]] ; then
  dpimode="lo"
# otherwise read the value from the file
else
  dpimode=`cat ~/.devenv/dpimode`
fi

if [[ "$dpimode" == "auto" ]] ; then
  echo "In auto mode"

  resolution_w=$(xdpyinfo | awk '/dimensions/{print $2}' | cut  -d"x" -f1)
  threshold_for_hdpi=3839 #Auto swap on dell XPS 4K screen (will also trigger on multi monitor :/ )
  # TODO do thresholding above based on proportions of screens dimensions, 
  # and/or screen count (additional mode(s) ? )
  if [ $resolution_w -ge $threshold_for_hdpi ] ; then
    set_hdpi
  else
    set_ldpi
  fi

elif [[ "$dpimode" == "lo" ]] ; then
  set_ldpi
elif [[ "$dpimode" == "hi" ]] ; then
  set_hdpi
else
  echo "ERROR - invalid mode in dpimode"
fi
