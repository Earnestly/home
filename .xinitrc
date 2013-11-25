#!/bin/bash

start-pulseaudio-x11 &
mpd &

# A better unclutter
hhpc -i 3 &

# Wallpaper
display -window root -resize '1366x768!' ~/.local/share/wall &

exec i3
