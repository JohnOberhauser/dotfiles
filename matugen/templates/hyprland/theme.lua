hl.config({
    general = {
        border_size = {{ okshell.sizing.border_width }},

        col = {
            active_border   = "rgb({{ colors.on_surface.dark.hex_stripped }})",
            inactive_border = "rgb({{ colors.primary.dark.hex_stripped }})",
        },
    },

    decoration = {
        rounding         = {{ okshell.sizing.radius_window }},
        active_opacity   = {{ okshell.opacity }},
        inactive_opacity = {{ okshell.opacity }},
    },

    group = {
        col = {
            border_active          = "rgb({{ colors.on_surface.dark.hex_stripped }})",
            border_inactive        = "rgb({{ colors.primary.dark.hex_stripped }})",
            border_locked_active   = "rgb({{ colors.on_surface.dark.hex_stripped }})",
            border_locked_inactive = "rgb({{ colors.primary.dark.hex_stripped }})",
        },

        groupbar = {
            text_color = "rgb({{ colors.on_surface.dark.hex_stripped }})",

            col = {
                active          = "rgb({{ colors.primary.dark.hex_stripped }})",
                inactive        = "rgb({{ colors.surface.dark.hex_stripped }})",
                locked_active   = "rgb({{ colors.primary.dark.hex_stripped }})",
                locked_inactive = "rgb({{ colors.surface.dark.hex_stripped }})",
            },
        },
    },
})