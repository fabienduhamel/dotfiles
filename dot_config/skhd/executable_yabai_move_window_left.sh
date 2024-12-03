#!/bin/zsh

window_id=$(yabai -m query --windows --window | jq -r .id)
window_pos_x=${${$(yabai -m query --windows --window | jq -r .frame.x)%.*}#-}
space_pos_x=${${$(yabai -m query --displays --window | jq -r .frame.x)%.*}#-}

if [ $window_pos_x = $space_pos_x ]; then
  # window is already at left of display, move to the prev one
  (yabai -m window $window_id --display prev --grid 1:2:1:0:1:1 && yabai -m window $window_id --focus) || \
    (yabai -m window $window_id --display next --grid 1:2:1:0:1:1 && yabai -m window $window_id --focus)
else
  # move window to the left
  yabai -m window --grid 1:2:0:0:1:1
fi

