local mainMod = "SUPER"

---- Apps / sessions ----

local home = os.getenv("HOME")

-- General
hl.bind(mainMod .. " + Q",            hl.dsp.window.close())
hl.bind(mainMod .. " + return",       hl.dsp.exec_cmd("uwsm app -- kitty --session fastfetch.session"))
hl.bind(mainMod .. " + ALT + return", hl.dsp.exec_cmd("uwsm app -- kitty --session dashboard.session"))
hl.bind(mainMod .. " + ALT + Y",      hl.dsp.exec_cmd("uwsm app -- yazi-kitty.sh"))
hl.bind(mainMod .. " + ALT + B",      hl.dsp.exec_cmd("uwsm app -- kitty -e btop"))
hl.bind(mainMod .. " + ALT + F",      hl.dsp.exec_cmd("uwsm app -- " .. home .. "/.local/share/firefox-nightly/firefox"))
hl.bind(mainMod .. " + ALT + I",      hl.dsp.exec_cmd("uwsm app -- " .. home .. "/.local/share/JetBrains/Toolbox/apps/intellij-idea/bin/idea"))
hl.bind(mainMod .. " + ALT + A",      hl.dsp.exec_cmd("uwsm app -- " .. home .. "/.local/share/JetBrains/Toolbox/apps/android-studio/bin/studio.sh"))
hl.bind(mainMod .. " + M",            hl.dsp.exec_cmd("uwsm stop"))

-- Window state
hl.bind(mainMod .. " + F",   hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",   hl.dsp.window.pseudo())             -- dwindle
hl.bind(mainMod .. " + V",   hl.dsp.layout("togglesplit"))       -- dwindle
hl.bind(mainMod .. " + F11", hl.dsp.window.fullscreen({ mode = 0 }))


---- Workspace navigation (r-1 / r+1 = relative incl. empty) ----

local prevWs = hl.dsp.focus({ workspace = "r-1" })
local nextWs = hl.dsp.focus({ workspace = "r+1" })

hl.bind(mainMod .. " + mouse_down", nextWs)
hl.bind(mainMod .. " + mouse_up",   prevWs)
hl.bind(mainMod .. " + kp_down",    nextWs)
hl.bind(mainMod .. " + kp_up",      prevWs)
hl.bind(mainMod .. " + down",       nextWs)
hl.bind(mainMod .. " + up",         prevWs)
hl.bind(mainMod .. " + next",       nextWs)
hl.bind(mainMod .. " + prior",      prevWs)
hl.bind(mainMod .. " + J",          nextWs)
hl.bind(mainMod .. " + K",          prevWs)

-- No-mod page nav
hl.bind("next",  nextWs)
hl.bind("prior", prevWs)


---- Move active window to next/prev workspace ----

local moveWindowPrev = hl.dsp.window.move({ workspace = "r-1" })
local moveWindowNext = hl.dsp.window.move({ workspace = "r+1" })

hl.bind(mainMod .. " + CTRL + mouse_down", moveWindowPrev)
hl.bind(mainMod .. " + CTRL + mouse_up",   moveWindowNext)
hl.bind(mainMod .. " + CTRL + kp_down",    moveWindowNext)
hl.bind(mainMod .. " + CTRL + kp_up",      moveWindowPrev)
hl.bind(mainMod .. " + CTRL + down",       moveWindowNext)
hl.bind(mainMod .. " + CTRL + up",         moveWindowPrev)
hl.bind(mainMod .. " + CTRL + next",       moveWindowNext)
hl.bind(mainMod .. " + CTRL + prior",      moveWindowPrev)
hl.bind(mainMod .. " + CTRL + J",          moveWindowNext)
hl.bind(mainMod .. " + CTRL + K",          moveWindowPrev)


---- Move window within / out of group ----

local function moveOrGroup(dir)
    return hl.dsp.window.groups.move_window_or_group({ direction = dir })
end

hl.bind(mainMod .. " + ALT + kp_left",  moveOrGroup("l"))
hl.bind(mainMod .. " + ALT + kp_right", moveOrGroup("r"))
hl.bind(mainMod .. " + ALT + kp_up",    moveOrGroup("u"))
hl.bind(mainMod .. " + ALT + kp_down",  moveOrGroup("d"))
hl.bind(mainMod .. " + ALT + left",     moveOrGroup("l"))
hl.bind(mainMod .. " + ALT + right",    moveOrGroup("r"))
hl.bind(mainMod .. " + ALT + up",       moveOrGroup("u"))
hl.bind(mainMod .. " + ALT + down",     moveOrGroup("d"))
hl.bind(mainMod .. " + ALT + H",        moveOrGroup("l"))
hl.bind(mainMod .. " + ALT + L",        moveOrGroup("r"))
hl.bind(mainMod .. " + ALT + K",        moveOrGroup("u"))
hl.bind(mainMod .. " + ALT + J",        moveOrGroup("d"))


---- Move focus ----

local function focusDir(dir)
    return hl.dsp.focus({ direction = dir })
end

hl.bind(mainMod .. " + SHIFT + kp_left",  focusDir("l"))
hl.bind(mainMod .. " + SHIFT + kp_right", focusDir("r"))
hl.bind(mainMod .. " + SHIFT + kp_up",    focusDir("u"))
hl.bind(mainMod .. " + SHIFT + kp_down",  focusDir("d"))
hl.bind(mainMod .. " + SHIFT + left",     focusDir("l"))
hl.bind(mainMod .. " + SHIFT + right",    focusDir("r"))
hl.bind(mainMod .. " + SHIFT + up",       focusDir("u"))
hl.bind(mainMod .. " + SHIFT + down",     focusDir("d"))
hl.bind(mainMod .. " + SHIFT + H",        focusDir("l"))
hl.bind(mainMod .. " + SHIFT + L",        focusDir("r"))
hl.bind(mainMod .. " + SHIFT + K",        focusDir("u"))
hl.bind(mainMod .. " + SHIFT + J",        focusDir("d"))


---- Groups ----
-- NOTE: confirm exact path for these on your hyprland version. Likely
-- hl.dsp.window.groups.*; some builds expose hl.dsp.window.group.* instead.

hl.bind(mainMod .. " + G",   hl.dsp.window.groups.toggle())
hl.bind(mainMod .. " + Tab", hl.dsp.window.groups.change_active())
hl.bind(mainMod .. " + L",   hl.dsp.window.groups.lock_active({ action = "toggle" }))


---- Mouse drag/resize ----

hl.bind(mainMod .. " + mouse:272",         hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",         hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + ALT + mouse:272",   hl.dsp.window.resize(), { mouse = true })


---- Volume / media ----

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("okshellctl audio volume-up"),   { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("okshellctl audio volume-down"), { locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("okshellctl audio mute"),        { locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"),         { locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"),               { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"),           { locked = true })


---- OkShell menus ----

hl.bind("print",                hl.dsp.exec_cmd("okshellctl menu screenshot"))
hl.bind(mainMod .. " + space",  hl.dsp.exec_cmd("okshellctl menu app-launcher"))
hl.bind(mainMod .. " + print",  hl.dsp.exec_cmd("okshellctl menu wallpaper"))
hl.bind("escape", hl.dsp.exec_cmd("okshellctl menu close-all"), { non_consuming = true })


---- Brightness ----

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("okshellctl brightness up"),   { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("okshellctl brightness down"), { locked = true })