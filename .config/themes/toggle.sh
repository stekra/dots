#!/usr/bin/bash

THEMES_DIR="$HOME/.config/themes"
CURRENT_FILE="$THEMES_DIR/current"

# Read current mode, default to dark
CURRENT=$(cat "$CURRENT_FILE" 2>/dev/null || echo "dark")

# Toggle
if [[ "$CURRENT" == "dark" ]]; then
  MODE="light"
else
  MODE="dark"
fi

echo "$MODE" > "$CURRENT_FILE"

# ── GTK ───────────────────────────────────────────────────────────────────────
gsettings set org.gnome.desktop.interface color-scheme "prefer-$MODE"

# ── Colors ────────────────────────────────────────────────────────────────────
source "$THEMES_DIR/$MODE/colors.sh"

# ── Hyprland ──────────────────────────────────────────────────────────────────
cat > "$HOME/.config/hypr/theme.conf" <<EOF
general {
    col.active_border = rgb(${BORDER})
    col.inactive_border = rgb(${BORDER_INACTIVE})
}

misc {
    background_color = rgb(${BACKGROUND})
}
EOF

# ── Reload ────────────────────────────────────────────────────────────────────
hyprctl reload
pkill -SIGUSR2 waybar

echo "Switched to $MODE"

