hl.window_rule({
    name = "skyrim fullscreen",
    match = {
        class = "steam_app_489830"
    },
    fullscreen = true
})

hl.window_rule({
    name = "wow fullscreen",
    match = {
        title = "World of Warcraft"
    },
    fullscreen = true
})

hl.window_rule({
    name = "kitty",
    match = {
        class = "kitty"
    },
    suppress_event = "maximize",
})
