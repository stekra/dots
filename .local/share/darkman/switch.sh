#!/bin/sh
case "$1" in
    dark)
        BG_COLOR="222222ff"
        BORDER_ACTIVE="ffffffff"
        BORDER_INACTIVE="808080ff"
        ;;

    light)
        BG_COLOR="e6e6e6ff"
        BORDER_ACTIVE="000000ff"
        BORDER_INACTIVE="808080ff"
        ;;
esac

sed -i "s/background-color.*/background-color \"#${BG_COLOR}\"/" ~/.config/niri/overrides.kdl
sed -i "s/active-color.*/active-color \"#${BORDER_ACTIVE}\"/" ~/.config/niri/overrides.kdl
sed -i "s/inactive-color.*/inactive-color \"#${BORDER_INACTIVE}\"/" ~/.config/niri/overrides.kdl

hyprctl -i 0 -r keyword misc:background_color       "rgba(${BG_COLOR})"
hyprctl -i 0 -r keyword general:col.active_border   "rgba(${BORDER_ACTIVE})"
hyprctl -i 0 -r keyword general:col.inactive_border "rgba(${BORDER_INACTIVE})"

