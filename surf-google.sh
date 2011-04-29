#!/bin/bash
# script to grab clipboard and display it to surf
# or realtime stream the clipboard if a youtube video.
# by: Jon Bradley
#
# requirements:
#   - youtube-dl
#   - xclip
#   - surf
#   - festival (optional)
#   - ogg123 (optional)

CLIPBOARD=$(xclip -o)
COOKIE_FILE=/var/tmp/youtube-dl-cookies.txt

# put this in the backup
# soon

# I want to use the =~ but does not seem to be working for me
#if [ "$CLIPBOARD" =~ 'http://' ]

if [ $(expr "$CLIPBOARD" : '\(http://www.youtube.com\)') ]
then
  ogg123 -q ~/.fvwm/sounds/bark.ogg
  date >> ~/.fvwm/youtube-sites.txt
  echo "---------" >> ~/.fvwm/youtube-sites.txt
  echo "${CLIPBOARD}" >> ~/.fvwm/youtube-sites.txt
  echo >> ~/.fvwm/youtube-sites.txt
  mplayer -cache 1024 -framedrop -quiet -cookies -cookies-file ${COOKIE_FILE} $(~/.fvwm/bin/youtube-dl -f 5 -g --cookies ${COOKIE_FILE} ${CLIPBOARD})
elif [ $(expr "$CLIPBOARD" : '\(http://\)') ]
then
  ogg123 -q ~/.fvwm/sounds/bell.ogg
  surf -s -p "$CLIPBOARD" &
  date >> ~/.fvwm/web-sites.txt
  echo "---------" >> ~/.fvwm/web-sites.txt
  echo "$CLIPBOARD" >> ~/.fvwm/web-sites.txt
  echo >> ~/.fvwm/web-sites.txt
else 
  echo "$CLIPBOARD" | festival --tts &
  surf -s -p "http://www.google.com/search?q=$CLIPBOARD"
fi

# EOF #
