#! /usr/bin/env zsh

window="$(yabai -m query --windows --window)"
display="$(yabai -m query --displays --window)"
coords="$(jq \
  --argjson window "${window}" \
  --argjson display "${display}" \
  -nr '(($display.frame | .x + .w / 2) - ($window.frame.w / 2) | tostring)
    + ":"
    + (($display.frame | .y + .h / 2) - ($window.frame.h / 2) | tostring)')"
yabai -m window --move "abs:${coords}"

