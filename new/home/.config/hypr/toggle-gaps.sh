#!/bin/bash
CURRENT=$(hyprctl getoption general:gaps_out | grep "custom type:" | awk '{print $3}')

if [ "$CURRENT" = "0" ]; then
    hyprctl keyword general:gaps_in 5
    hyprctl keyword general:gaps_out 10
    hyprctl keyword general:border_size 1
else
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0
    hyprctl keyword general:border_size 0
fi
