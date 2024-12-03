#!/bin/zsh

window_pos_x=${$(yabai -m query --windows --window | jq -r .frame.x)%.*}
window_width=${$(yabai -m query --windows --window | jq -r .frame.w)%.*}
space_pos_x=${$(yabai -m query --displays --window | jq -r .frame.x)%.*}
space_width=${$(yabai -m query --displays --window | jq -r .frame.w)%.*}

window_right_offset=${$((window_pos_x + window_width))#-}
space_right_offset=${$((space_pos_x + space_width))#-}

if [ $window_right_offset = $space_right_offset ]; then
  # window is already at right of display, move to the next one
  (yabai -m window --display next --grid 1:2:0:0:1:1 && yabai -m display --focus next) ||\
    (yabai -m window --display prev --grid 1:2:0:0:1:1 && yabai -m display --focus prev)
else
  # move window to the right
  yabai -m window --grid 1:2:1:0:1:1
fi

