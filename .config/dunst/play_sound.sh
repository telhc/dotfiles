#!/bin/sh
if [ "$(<$HOME/.cache/mute_notif)" = "0" ]; then
  paplay /usr/share/sounds/freedesktop/stereo/message-new-instant.oga --volume=150000
fi
