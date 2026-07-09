-- By Mac Cygwin
-- Hyprland 0.55+ Lua config
-- Converted from hyprland.conf

-- NOTE: macchiato.conf must be converted to macchiato.lua separately.
-- It should return a table, then uncomment:
-- local macchiato = require("macchiato")

-- Load pywal colors from ~/.cache/wal/colors.lua
-- colors.lua uses #rrggbb hex strings; Hyprland wants rgb(rrggbb).
-- loadfile() is required since the path is outside ~/.config/hypr/.
local _wal_raw = loadfile(os.getenv("HOME") .. "/.cache/wal/colors.lua")()

-- Convert all hex values to Hyprland rgb() format, pass non-hex values through.
local wal = {}
for k, v in pairs(_wal_raw) do
    if type(v) == "string" and v:sub(1, 1) == "#" then
        wal[k] = "rgb(" .. v:sub(2) .. ")"
    else
        wal[k] = v  -- e.g. wal.wallpaper stays as a plain path string
    end
end
-- wal.color1 → "rgb(9D6F93)", wal.background → "rgb(190c1d)", etc.

--------------------
---- MONITORS ----
--------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = "eDP-1",  mode = "highres",       position = "0x0",  scale = 1 })
hl.monitor({ output = "DP-1",   mode = "1920x1080@144", position = "auto", scale = 1 })

-----------------------
---- MY PROGRAMS ----
-----------------------

local lock        = "hyprlock"
local terminal    = "kitty"
local fileManager = "pcmanfm"
local menu        = "wofi"
local logoutMenu  = "wlogout -b 4"
local wallChange  = os.getenv("HOME") .. "/.config/hypr/scripts/wallp_cycle.sh"
local screenshot  = 'grim -g "$(slurp)" >(tee ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png | wl-copy --type image/png) && notify-send "Saved to ~/Pictures and copied"'

--------------------
---- AUTOSTART ----
--------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
-- exec-once is now hl.on("hyprland.start", ...)
hl.on("hyprland.start", function()
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprctl setcursor Catppuccin-Macchiato-Red 24")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("swaync")
    hl.exec_cmd("wal -R")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")   -- Stores only text data
    hl.exec_cmd("wl-paste --type image --watch cliphist store")  -- Stores only image data
    hl.exec_cmd("pw-play " .. os.getenv("HOME") .. "/.config/hypr/macos.wav")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("cliphist wipe")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- NOTE: If you use uwsm, set these in ~/.config/uwsm/env instead
hl.env("XCURSOR_SIZE",                "24")
hl.env("GDK_BACKEND",                 "wayland,x11,*")
hl.env("QT_QPA_PLATFORM",             "wayland;xcb")
hl.env("SDL_VIDEODRIVER",             "wayland")
hl.env("CLUTTER_BACKEND",             "wayland")
hl.env("QT_QPA_PLATFORMTHEME",        "qt6ct")
hl.env("ELECTRON_OZONE_PLATFORM_HINT","auto")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in     = 3,
        gaps_out    = 5,
        border_size = 2,
        col = {
            active_border   = wal.color1,
            inactive_border = wal.background,
        },
        layout        = "scrolling",
        allow_tearing = false,
    },

    decoration = {
        rounding = 20,
        blur = {
            enabled = true,
            size    = 3,
            passes  = 1,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        force_default_wallpaper = 0,
    },

    debug = {
        vfr = true,
    },
})

--------------------
---- SCROLLING ----
--------------------

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
        column_width             = 0.7,
    },
})

--------------------
---- ANIMATIONS ----
--------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",         enabled = true, speed = 7,  bezier = "myBezier", style = "popin" })
hl.animation({ leaf = "windowsOut",      enabled = true, speed = 7,  bezier = "default",  style = "slide bottom" })
hl.animation({ leaf = "border",          enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",            enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "layers",          enabled = true, speed = 7,  bezier = "myBezier", style = "slide bottom" })
hl.animation({ leaf = "workspaces",      enabled = true, speed = 6,  bezier = "myBezier", style = "slidefadevert 50%" })
hl.animation({ leaf = "specialWorkspace",enabled = true, speed = 6,  bezier = "myBezier", style = "slidefadevert 50%" })

---------------
---- INPUT ----
---------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",
        follow_mouse = 1,
        sensitivity  = 0, -- -1.0 to 1.0, 0 means no modification
        touchpad = {
            natural_scroll = true,
            scroll_factor  = 0.2,
        },
    },
})

-- Per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

--------------------
---- LAYER RULES ----
--------------------

hl.layer_rule({
    match     = { namespace = "waybar" },
    animation = "slide top",
})

----------------------
---- WINDOW RULES ----
----------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
hl.window_rule({
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    match   = { class = "pcmanfm" },
    opacity = "0.78",
})

hl.window_rule({
    match  = { class = "com.saivert.pwvucontrol" },
    float  = true,
    center = true,
})

hl.window_rule({
    match  = { class = "blueman-manager" },
    float  = true,
    center = true,
})

---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local mainMod = "SUPER"

-- Apps & actions
hl.bind(mainMod .. " + Q",      hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + W",      hl.dsp.window.close())
hl.bind(mainMod .. " + M",      hl.dsp.exec_cmd(logoutMenu))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + space",      hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + J",      hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + L",      hl.dsp.exec_cmd(lock))
hl.bind(mainMod .. " + F",      hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + G",      hl.dsp.exec_cmd("bash -c '" .. screenshot .. "'"))
hl.bind(mainMod .. " + K",      hl.dsp.exec_cmd(wallChange))
hl.bind(mainMod .. " + H",      hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + N",      hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("wofi-emoji"))
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))

-- Media keys (bindel = locked + repeating)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume 5"),           { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume -5"),          { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness +10"),            { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness -10"),            { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",         hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"), { locked = true, repeating = true })


-- Scrolling layout keybinds
hl.bind(mainMod .. " + bracketright",         hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + bracketleft",          hl.dsp.layout("move -col"))
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + bracketleft",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + up",           hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down",         hl.dsp.window.swap({ direction = "d" }))
hl.bind(mainMod .. " + equal",                hl.dsp.layout("colresize +0.1"))
hl.bind(mainMod .. " + minus",                hl.dsp.layout("colresize -0.1"))
hl.bind(mainMod .. " + P",                    hl.dsp.layout("promote"))
hl.bind(mainMod .. " + SHIFT + F",            hl.dsp.layout("fit visible"))
hl.bind(mainMod .. " + SHIFT + right",        hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + SHIFT + left",         hl.dsp.layout("swapcol l"))

-- Focus with arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))

-- Switch workspaces / move windows with mainMod + [0-9]
for i = 1, 10 do
    local key = i % 10  -- key 0 maps to workspace 10
    hl.bind(mainMod .. " + " .. key,          hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,  hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB (bindm equivalent)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
