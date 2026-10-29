#!/usr/bin/bash

THEMES_DIR="$HOME/.config/themes"
CURRENT_FILE="$THEMES_DIR/current"

# Read current mode, default to dark
CURRENT=$(cat "$CURRENT_FILE" 2>/dev/null || echo "dark")

if [[ "$CURRENT" == "dark" ]]; then
    MODE="light"
else
    MODE="dark"
fi

# Save new mode
echo "$MODE" > "$CURRENT_FILE"

# Load colors
source "$THEMES_DIR/$MODE/colors.sh"

# GTK
gsettings set org.gnome.desktop.interface color-scheme "prefer-$MODE"

# Waybar
cat > "$HOME/.config/waybar/theme.css" <<EOF
@define-color theme_bg_color #${BG};
@define-color theme_fg_color #${FG_ACTIVE};
EOF

# Hyprland
cat > "$HOME/.config/hypr/theme.lua" <<EOF
local theme = {}

theme.active_border = 'rgb(${FG_ACTIVE})'
theme.inactive_border = 'rgb(${FG_INACTIVE})'
theme.background_color = 'rgb(${BG})'

return theme
EOF

# Rofi
cat > "$HOME/.config/rofi/colors.rasi" <<EOF
* {
    fg:       #${FG_ACTIVE};
    fg-dim:   #${FG_INACTIVE}66;
    bg:       #${BG}66;
    bg-solid: #${BG};
}
EOF

# Mako (only the global section, before the first [criteria] block)
sed -i \
    -e "1,/^\[/ s/^text-color=.*/text-color=#${FG_ACTIVE}ff/" \
    -e "1,/^\[/ s/^background-color=.*/background-color=#${BG}66/" \
    -e "1,/^\[/ s/^border-color=.*/border-color=#${FG_INACTIVE}ff/" \
    -e "1,/^\[/ s/^progress-color=.*/progress-color=#${FG_ACTIVE}ff/" \
    -e "/^\[app-name=osd\]/,/^\[/ s/^text-color=.*/text-color=#$(printf '%06x' $((0xFFFFFF ^ 0x${FG_ACTIVE})))ff/" \
    "$HOME/.config/mako/config"

# Foot (initial theme for new standalone instances; signal switches running ones,
# and a foot --server applies it to all current and future clients)
sed -i "s/^initial-color-theme=[a-z]*/initial-color-theme=${MODE}/" "$HOME/.config/foot/foot.ini"
if [[ "$MODE" == "dark" ]]; then
    pkill -USR1 -x foot
else
    pkill -USR2 -x foot
fi

# Reload
makoctl reload
hyprctl reload
# pkill -SIGUSR2 waybar # not needed due to live css reload

echo "Switched to $MODE mode"
