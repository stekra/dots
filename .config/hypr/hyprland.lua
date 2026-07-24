local theme = require('theme')

hl.monitor({
    output = '',
    mode = 'preferred',
    position = 'auto',
    scale = '1',
})

hl.monitor({
    output = 'eDP-1',
    mode = 'preferred',
    position = 'auto',
    scale = '1.2',
})

hl.monitor({
    output = 'HDMI-A-2',
    mode = '1920x1080@120',
    position = 'auto',
    scale = '1',
})

hl.env('GDK_BACKEND', 'wayland,x11,*')
hl.env('QT_QPA_PLATFORM', 'wayland;xcb')
hl.env('CLUTTER_BACKEND', 'wayland')

hl.env('XDG_CURRENT_DESKTOP', 'Hyprland')
hl.env('XDG_SESSION_TYPE', 'wayland')
hl.env('XDG_SESSION_DESKTOP', 'Hyprland')

hl.env('QT_AUTO_SCREEN_SCALE_FACTOR', '1')
hl.env('QT_QPA_PLATFORM', 'wayland;xcb')
hl.env('QT_WAYLAND_DISABLE_WINDOWDECORATION', '1')
hl.env('QT_QPA_PLATFORMTHEME', 'qt5ct')

hl.env('MOZ_ENABLE_WAYLAND', '1')
hl.env('ELECTRON_OZONE_PLATFORM_HINT', 'wayland')
hl.env('OZONE_PLATFORM', 'wayland')

hl.env('HYPRCURSOR_THEME', 'macos-tahoe-cursor')
hl.env('HYPRCURSOR_SIZE', '28')
hl.env('XCURSOR_THEME', 'macos-tahoe-cursor')
hl.env('XCURSOR_SIZE', '28')

hl.env('TERMINAL', 'ghostty')
hl.env('TERM', 'ghostty')

hl.on('hyprland.start', function()
    hl.exec_cmd('waybar')
    hl.exec_cmd('wl-clip-persist --clipboard regular')
    hl.exec_cmd('walker --gapplication-service')
    hl.exec_cmd('ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false')
    hl.exec_cmd('hyprsunset')
    hl.exec_cmd('sunshine')
    hl.exec_cmd('steam -silent')
end)

hl.config({
    general = {
        gaps_in = 1,
        gaps_out = 0,
        border_size = 0,

        col = {
            active_border = theme.active_border,
            inactive_border = theme.inactive_border,
        },

        resize_on_border = true,
        allow_tearing = true,
        layout = 'scrolling',

        snap = {
            enabled = true,
            respect_gaps = true,
        },
    },

    decoration = {
        rounding = 0,
        rounding_power = 4,
        active_opacity = 1.0,
        inactive_opacity = 0.7,

        shadow = {
            enabled = false,
            range = 200,
            render_power = 3,
            offset = { 0, 50 },
            color = 'rgba(00000044)',
            color_inactive = 'rgba(00000022)',
            scale = 0.9,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve('easeOutQuint',   { type = 'bezier', points = { { 0.23, 1 },    { 0.32, 1 } } })
hl.curve('easeInOutCubic', { type = 'bezier', points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve('linear',         { type = 'bezier', points = { { 0, 0 },       { 1, 1 }    } })
hl.curve('almostLinear',   { type = 'bezier', points = { { 0.5, 0.5 },   { 0.75, 1 } } })
hl.curve('quick',          { type = 'bezier', points = { { 0.15, 0 },    { 0.1, 1 }  } })

hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",     enabled = true, speed = 2, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 2, bezier = "easeOutQuint", style = "popin 95%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "linear",       style = "popin 95%" })
hl.animation({ leaf = "fade",       enabled = true, speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "layers",     enabled = false })

hl.config({
    dwindle = {
        force_split = 2,
        preserve_split = true,
    },
})

hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
        wrap_focus = false,
        wrap_swapcol = false,
    },
})

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        background_color = theme.background_color,
    }
})

hl.config({
    input = {
        kb_layout = 'us',
        kb_options = 'ctrl:nocaps, altwin:swap_alt_win',
        repeat_rate = 30,
        repeat_delay = 180,
        follow_mouse = 2,
        sensitivity = 0,
        -- accel_profile = 'flat',
        natural_scroll = true,

        touchpad = {
            natural_scroll = true,
            tap_to_click = false,
        },
    }
})

hl.gesture({
    fingers = 3,
    direction = 'vertical',
    action = 'workspace',
})

hl.config({
    binds = {
        scroll_event_delay = 0,
    },

    render = {
        direct_scanout = 2,
    },

    cursor = {
        hide_on_key_press = true,
    },

    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})

hl.bind('SUPER + Return', hl.dsp.exec_cmd('ghostty --gtk-single-instance=true'))
hl.bind('SUPER + T', hl.dsp.exec_cmd('ghostty --gtk-single-instance=true'))
hl.bind('SUPER + W', hl.dsp.window.close())
hl.bind('SUPER + Q', hl.dsp.window.kill())
hl.bind('SUPER + E', hl.dsp.exec_cmd('nautilus --new-window'))
hl.bind('SUPER + B', hl.dsp.exec_cmd('firefox'))
hl.bind('SUPER + Y', hl.dsp.exec_cmd('firefox --new-window https://www.youtube.com/feed/subscriptions'))
hl.bind('SUPER + F', hl.dsp.window.fullscreen())
hl.bind('SUPER + SHIFT + F', hl.dsp.window.float())
hl.bind('SUPER + SPACE', hl.dsp.exec_cmd('launch-walker'))
hl.bind('SUPER + P', hl.dsp.window.pseudo())
hl.bind('SUPER + R', hl.dsp.layout('colresize +conf'))
hl.bind('SUPER + SHIFT + R', hl.dsp.layout('colresize -conf'))
hl.bind('SUPER + SHIFT + D', hl.dsp.exec_cmd('~/.config/themes/toggle.sh'))

local function bind_win(direction, keys)
    local dir = {
        left =  { x = -50, y = 0,   relative = true },
        right = { x = 50,  y = 0,   relative = true },
        up =    { x = 0,   y = -50, relative = true },
        down =  { x = 0,   y = 50,  relative = true },
    }

    for _, key in ipairs(keys) do
        hl.bind('SUPER + ' .. key, hl.dsp.focus({ direction = direction }))
        hl.bind('SUPER + CTRL + ' .. key, hl.dsp.window.resize(dir[direction]))
    end
end

bind_win('left',  { 'left',  'h' })
bind_win('right', { 'right', 'l' })
bind_win('up',    { 'up',    'k' })
bind_win('down',  { 'down',  'j' })

hl.bind('SUPER + SHIFT + left', hl.dsp.layout('consume_or_expel prev'))
hl.bind('SUPER + SHIFT + h', hl.dsp.layout('consume_or_expel prev'))
hl.bind('SUPER + SHIFT + right', hl.dsp.layout('consume_or_expel next'))
hl.bind('SUPER + SHIFT + l', hl.dsp.layout('consume_or_expel next'))

for i = 1, 10 do
    local key = i % 10
    hl.bind('SUPER' .. ' + ' .. key,   hl.dsp.focus({ workspace = i}))
    hl.bind('SUPER + SHIFT + ' .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind('SUPER + mouse_down', hl.dsp.focus({ workspace = 'e+1' }))
hl.bind('SUPER + mouse_up',   hl.dsp.focus({ workspace = 'e-1' }))

hl.bind('SUPER + I', hl.dsp.exec_cmd('hyprpicker -a'))
hl.bind('SUPER + CTRL + Q', hl.dsp.exec_cmd('hyprlock'))

hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_cmd('wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && volume-osd'), { locked = true, repeating = true })
hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd('wpctl set-volume      @DEFAULT_AUDIO_SINK@ 5%- && volume-osd'), { locked = true, repeating = true })
hl.bind('XF86AudioMute',        hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'),      { locked = true, repeating = true })
hl.bind('XF86AudioMicMute',     hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'),    { locked = true, repeating = true })
hl.bind('XF86MonBrightnessUp',  hl.dsp.exec_cmd('brightnessctl -e4 -n2 set 5%+ && brightness-osd'), { locked = true, repeating = true })
hl.bind('XF86MonBrightnessDown',hl.dsp.exec_cmd('brightnessctl -e4 -n2 set 5%- && brightness-osd'), { locked = true, repeating = true })

hl.bind('Pause',       hl.dsp.exec_cmd('wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && volume-osd'), { locked = true, repeating = true })
hl.bind('Scroll_Lock', hl.dsp.exec_cmd('wpctl set-volume      @DEFAULT_AUDIO_SINK@ 5%- && volume-osd'), { locked = true, repeating = true })

hl.bind('XF86AudioNext',  hl.dsp.exec_cmd('playerctl next'),       { locked = true })
hl.bind('XF86AudioPause', hl.dsp.exec_cmd('playerctl play-pause'), { locked = true })
hl.bind('XF86AudioPlay',  hl.dsp.exec_cmd('playerctl play-pause'), { locked = true })
hl.bind('XF86AudioPrev',  hl.dsp.exec_cmd('playerctl previous'),   { locked = true })

hl.window_rule({
    name  = 'suppress-maximize-events',
    match = { class = '.*' },
    suppress_event = 'maximize',
})

hl.window_rule({
    name  = 'fix-xwayland-drags',
    match = {
        class      = '^$',
        title      = '^$',
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name = "picture-in-picture",
    match = { title = "Picture-in-Picture" },
    float = true,
    pin = true,
    keep_aspect_ratio = true,
})

hl.window_rule({
    name = 'steam-gamescope-tearing',
    match = {
        class = 'steam_app|gamescope',
    },
    immediate = true,
})

