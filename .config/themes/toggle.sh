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

# Quickshell (only where it's set up; it reloads the file itself)
if [[ -d "$HOME/.config/quickshell" ]]; then
cat > "$HOME/.config/quickshell/theme.json" <<EOF
{ "bg": "#${BG}", "fg": "#${FG_ACTIVE}" }
EOF
fi

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

# Foot (initial theme for new standalone instances; signal switches running ones,
# and a foot --server applies it to all current and future clients)
sed -i "s/^initial-color-theme=[a-z]*/initial-color-theme=${MODE}/" "$HOME/.config/foot/foot.ini"
if [[ "$MODE" == "dark" ]]; then
    pkill -USR1 -x foot
else
    pkill -USR2 -x foot
fi

# Reload
hyprctl reload

echo "Switched to $MODE mode"
