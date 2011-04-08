#!/bin/bash

if [[ $(netcfg status) =~ 'tuxracer' ]]
then
	rsync --archive -e ssh ~/_Help/ kreator@breadbox:~/_Help
else
	rsync --archive -e ssh ~/_Help/ kreator@breadbox.ath.cx:~/_Help
fi

