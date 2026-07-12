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

# Reload
hyprctl reload
# pkill -SIGUSR2 waybar # not needed due to live css reload

echo "Switched to $MODE mode"
