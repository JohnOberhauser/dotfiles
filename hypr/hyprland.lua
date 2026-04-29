require("conf.monitors")
require("conf.keybinds")
require("conf.windowRules")
require("conf.theme")
require("conf.font")
require("conf.layerRules")


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE",    "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("GTK_USE_PORTAL", "1")        -- terminal file chooser
hl.env("GDK_DEBUG",      "portals")  -- terminal file chooser

hl.env("QT_STYLE_OVERRIDE",  "kvantum")


-------------------
---- AUTOSTART ----
-------------------

local home = os.getenv("HOME")

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("play " .. home .. "/.config/hypr/assets/sounds/desktop-login.oga")

    hl.exec_cmd("uwsm app -- " .. home .. "/.config/hypr/scripts/launchers/firefoxHomePageServer.sh")
    hl.exec_cmd("uwsm app -- " .. home .. "/.config/hypr/scripts/launchers/opentabletdriver.sh")
    hl.exec_cmd("uwsm app -- okshell")
    hl.exec_cmd("uwsm app -- udiskie -anT")
    hl.exec_cmd("uwsm app -- syncthing")
end)


-----------------
---- GENERAL ----
-----------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,
        layout   = "dwindle",
    },

    cursor = {
        no_warps = true,
    },

    decoration = {
        blur = {
            enabled = true,
            size    = 6,
            passes  = 3,
            xray    = true,
        },
        shadow = {
            enabled = false,
        },
    },

    misc = {
        disable_hyprland_logo           = true,
        disable_hyprland_guiutils_check = true,
        enable_anr_dialog               = false,
        session_lock_xray               = true,
    },

    dwindle = {
        pseudotile      = true,  -- toggled with mainMod + P
        preserve_split  = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },

    ecosystem = {
        no_update_news  = true,
        no_donation_nag = true,
    },

    -- Fix kitty colors being slightly off
    -- https://github.com/hyprwm/Hyprland/discussions/12788
    render = {
        cm_sdr_eotf = 2,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout                   = "us",
        numlock_by_default          = false,
        float_switch_override_focus = 0,
        follow_mouse                = 2,

        touchpad = {
            scroll_factor = 0.2,
            drag_lock     = true,
            ["tap-and-drag"] = true,  -- key has a hyphen, so use bracket syntax
        },
    },
})


-- Per-device config (find names with `hyprctl devices`)
hl.device({
    name        = "logitech-usb-receiver",
    sensitivity = -0.3,
})

hl.device({
    name        = "e-signal-usb-gaming-mouse",
    sensitivity = -0.8,
})


------------------
---- GESTURES ----
------------------

hl.gesture({
    fingers   = 3,
    direction = "vertical",
    action    = "workspace",
})

hl.config({
    gestures = {
        workspace_swipe_invert = false,
    },
})


--------------------
---- ANIMATIONS ----
--------------------

hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("myBezier",     { type = "bezier", points = { {0.05, 0.9}, {0.1, 1}  } })
hl.curve("workspaceBez", { type = "bezier", points = { {0.61, 1},   {0.88, 1} } })

hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3,  bezier = "workspaceBez", style = "slidevert" })