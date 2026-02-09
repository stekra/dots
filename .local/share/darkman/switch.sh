#!/bin/sh
case "$1" in
    dark)
        BG_COLOR="222222"
        BORDER_ACTIVE="ffffff"
        BORDER_INACTIVE="808080"
        ;;

    light)
        BG_COLOR="e6e6e6"
        BORDER_ACTIVE="000000"
        BORDER_INACTIVE="808080"
        ;;
esac

sed -i "s/background-color.*/background-color \"#${BG_COLOR}\"/" ~/.config/niri/overrides.kdl
sed -i "s/active-color.*/active-color \"#${BORDER_ACTIVE}\"/" ~/.config/niri/overrides.kdl
sed -i "s/inactive-color.*/inactive-color \"#${BORDER_INACTIVE}\"/" ~/.config/niri/overrides.kdl

hyprctl -i 0 -r keyword misc:background_color       "rgb(${BG_COLOR})"
hyprctl -i 0 -r keyword general:col.active_border   "rgb(${BORDER_ACTIVE})"
hyprctl -i 0 -r keyword general:col.inactive_border "rgb(${BORDER_INACTIVE})"

