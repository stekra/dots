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

hl.env('TERMINAL', 'footclient')
hl.env('TERM', 'footclient')

hl.env('GTK_IM_MODULE', 'simple')

hl.on('hyprland.start', function()
    hl.exec_cmd('waybar')
    hl.exec_cmd('wl-clip-persist --clipboard regular')
    hl.exec_cmd('ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false')
    hl.exec_cmd('hyprsunset')
    hl.exec_cmd('gnome-keyring-daemon --start -- components=secret')
    -- hl.exec_cmd('sunshine')
    -- hl.exec_cmd('steam -silent')
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
        rounding = 8,
        rounding_power = 4,
        active_opacity = 1.0,
        inactive_opacity = 0.8,

        shadow = {
            enabled = true,
            range = 100,
            render_power = 2,
            offset = { 0, 20 },
            color = 'rgba(22222244)',
            color_inactive = 'rgba(00000022)',
            scale = 0.9,
        },

        blur = {
            enabled = true,
            passes = 2,
        },

        motion_blur = {
            enabled = true,
            samples = 2,
        }
    },

    animations = {
        enabled = true,
    },
})

hl.curve('easeOutQuint', { type = 'bezier', points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve('linear',       { type = 'bezier', points = { { 0,    0 }, { 1,    1 } } })

hl.curve('spring',       { type = 'spring', mass = 1, stiffness = 1250, dampening = 65 })
hl.curve('spring-stiff', { type = 'spring', mass = 1, stiffness = 1560, dampening = 75 })
hl.curve('bounce',       { type = 'spring', mass = 1, stiffness = 1800, dampening = 50 })

hl.animation({ leaf = 'global',      enabled = true, speed = 1, spring = 'spring' })
hl.animation({ leaf = 'windowsMove', enabled = true, speed = 1, spring = 'spring' })
hl.animation({ leaf = 'workspaces',  enabled = true, speed = 1, spring = 'spring-stiff', style = 'slidevert' })
hl.animation({ leaf = 'windowsIn',   enabled = true, speed = 1, spring = 'spring',       style = 'popin 90%' })
hl.animation({ leaf = 'windowsOut',  enabled = true, speed = 1, bezier = 'linear',       style = 'popin 90%' })
hl.animation({ leaf = 'fade',        enabled = true, speed = 1, bezier = 'easeOutQuint' })
hl.animation({ leaf = 'layers',      enabled = true, speed = 1, spring = 'bounce',       style = 'popin 80%' })

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
        middle_click_paste = false,
    }
})

hl.config({
    input = {
        kb_layout = 'usmac',
        -- kb_options = 'ctrl:nocaps',
        kb_options = 'ctrl:nocaps, altwin:swap_alt_win',
        repeat_rate = 30,
        repeat_delay = 225,
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

hl.device({
    name = "stefan’s-magic-keyboard",
    kb_options = 'ctrl:nocaps',
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
        zoom_disable_aa = true,
    },

    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})

hl.bind('SUPER + Return', hl.dsp.exec_cmd('footclient'))
hl.bind('SUPER + T', hl.dsp.exec_cmd('footclient'))
-- hl.bind('SUPER + Return', hl.dsp.exec_cmd('ghostty --gtk-single-instance=true'))
-- hl.bind('SUPER + T', hl.dsp.exec_cmd('ghostty --gtk-single-instance=true'))
hl.bind('SUPER + W', hl.dsp.window.close())
hl.bind('SUPER + Q', hl.dsp.window.kill())
hl.bind('SUPER + E', hl.dsp.exec_cmd('nautilus --new-window'))
hl.bind('SUPER + B', hl.dsp.exec_cmd('firefox'))
hl.bind('SUPER + Y', hl.dsp.exec_cmd('firefox --new-window https://www.youtube.com/feed/subscriptions'))
hl.bind('SUPER + F', hl.dsp.window.fullscreen())
hl.bind('SUPER + SHIFT + F', hl.dsp.window.float())
hl.bind('SUPER + SPACE', hl.dsp.exec_cmd('pkill rofi || rofi -show drun'))
hl.bind('SUPER + CONTROL + SPACE', hl.dsp.exec_cmd('pkill rofi || rofimoji'))
hl.bind('SUPER + SHIFT + SPACE', hl.dsp.exec_cmd('pkill rofi || rofi -show calc -theme-str "listview { enabled: false; }"'))
hl.bind('SUPER + P', hl.dsp.window.pseudo())
hl.bind('SUPER + R', hl.dsp.layout('colresize +conf'))
hl.bind('SUPER + SHIFT + R', hl.dsp.layout('colresize -conf'))
hl.bind('SUPER + SHIFT + C', hl.dsp.layout('center'))
hl.bind('SUPER + SHIFT + D', hl.dsp.exec_cmd('~/.config/themes/toggle.sh'))

for _, d in ipairs {
    { 'left',  'h', -50,   0, hl.dsp.layout('consume_or_expel prev') },
    { 'right', 'l',  50,   0, hl.dsp.layout('consume_or_expel next') },
    { 'up',    'k',   0, -50, hl.dsp.window.move { direction = 'u' } },
    { 'down',  'j',   0,  50, hl.dsp.window.move { direction = 'd' } },
} do
    local dir, vim, x, y, shift = table.unpack(d)
    local focus = hl.dsp.layout('focus ' .. dir:sub(1, 1))
    for _, key in ipairs { dir, vim } do
        hl.bind('SUPER + ' .. key,         focus)
        hl.bind('SUPER + CTRL + ' .. key,  hl.dsp.window.resize { x = x, y = y, relative = true })
        hl.bind('SUPER + SHIFT + ' .. key, shift)
    end
end
hl.gesture({ fingers = 3, direction = 'horizontal', action = 'scroll_move' })
hl.gesture({ fingers = 4, direction = 'horizontal', action = 'scroll_move' })

hl.gesture({ fingers = 3, direction = 'vertical', action = 'workspace' })
hl.gesture({ fingers = 4, direction = 'vertical', action = 'workspace' })

for i = 1, 10 do
    local key = i % 10
    hl.bind('SUPER' .. ' + ' .. key,   hl.dsp.focus({ workspace = i}))
    hl.bind('SUPER + SHIFT + ' .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind('SUPER + mouse_down', hl.dsp.focus({ workspace = 'e+1' }))
hl.bind('SUPER + mouse_up',   hl.dsp.focus({ workspace = 'e-1' }))

hl.bind('SUPER + mouse:272', hl.dsp.window.drag(),   { mouse = true })
hl.bind('SUPER + mouse:273', hl.dsp.window.resize(), { mouse = true })

hl.gesture({ fingers = 2, mods = 'SUPER', direction = 'pinch', action = 'cursorZoom', zoom_level = 1, mode = 'live' })

local function zoom(offset)
    local current = hl.get_config('cursor.zoom_factor')
    if offset ~= nil then
        current = current + offset
    else
        current = 1
    end
    current = math.max(1, math.min(5, current))
    hl.config({ cursor = { zoom_factor = current } })
end
hl.bind('SUPER + equal', function() zoom(0.3) end, { repeating = true })
hl.bind('SUPER + minus', function() zoom(-0.3) end, { repeating = true })
hl.bind('CTRL + mouse_down', function() zoom(0.3) end)
hl.bind('CTRL + mouse_up', function() zoom(-0.3) end)

hl.bind('SUPER + I', hl.dsp.exec_cmd('hyprpicker -a'))
hl.bind('SUPER + CTRL + Q', hl.dsp.exec_cmd('hyprlock'))

hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_cmd('volume-osd up'), { locked = true, repeating = true })
hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd('volume-osd down'), { locked = true, repeating = true })
hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd('volume-osd down'), { locked = true, repeating = true })
hl.bind('XF86AudioMute',        hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'),      { locked = true, repeating = true })
hl.bind('XF86AudioMicMute',     hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'),    { locked = true, repeating = true })
hl.bind('XF86MonBrightnessUp',  hl.dsp.exec_cmd('brightness-osd up'), { locked = true, repeating = true })
hl.bind('XF86MonBrightnessDown',hl.dsp.exec_cmd('brightness-osd down'), { locked = true, repeating = true })

hl.bind('Pause',       hl.dsp.exec_cmd('volume-osd up'), { locked = true, repeating = true })
hl.bind('Scroll_Lock', hl.dsp.exec_cmd('volume-osd down'), { locked = true, repeating = true })

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

hl.window_rule({
    name = 'float-sushi-nautilus-preview',
    match = {
        class = 'org.gnome.NautilusPreviewer',
    },
    float = true,
    center = true,
    size = { 'monitor_w * 0.7', 'monitor_h * 0.7' },
    no_initial_focus = true,
})

hl.layer_rule({
    name  = 'rofi-blur',
    match = { namespace = '^rofi$' },
    blur = true,
    ignore_alpha = 0.01,
})

hl.layer_rule({
    name  = 'mako-blur',
    match = { namespace = '^notifications$' },
    blur = true,
    ignore_alpha = 0.01,
})

