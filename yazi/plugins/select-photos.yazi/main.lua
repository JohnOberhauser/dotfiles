--- select-photos.yazi — recursively select every image under the current directory
--- Usage (keymap.toml): run = "plugin select-photos"        (select)
---                      run = "plugin select-photos off"    (deselect)

local EXTS = {
    "jpg", "jpeg", "png", "webp", "gif", "bmp",
    "tif", "tiff", "avif", "heic", "heif",
}

-- `ya.emit` is the current name; fall back for older Yazi versions.
local emit = ya.emit or ya.mgr_emit or ya.manager_emit

local get_cwd = ya.sync(function()
    return tostring(cx.active.current.cwd)
end)

local function notify(msg, level)
    ya.notify { title = "Select photos", content = msg, timeout = 3, level = level or "info" }
end

return {
    entry = function(_, job)
        local state = (job.args and job.args[1]) or "on"
        local cwd = get_cwd()

        local cmd = Command("fd")
            :arg("--type"):arg("f")
            :arg("--no-ignore") -- don't skip files listed in .gitignore etc.
            :arg("--absolute-path")
        for _, ext in ipairs(EXTS) do
            cmd = cmd:arg("--extension"):arg(ext)
        end

        local output, err = cmd
            :arg(".")
            :arg(cwd)
            :stdout(Command.PIPED)
            :stderr(Command.PIPED)
            :output()

        if not output then
            return notify("Failed to run fd: " .. tostring(err), "error")
        end
        if not output.status.success then
            return notify("fd failed: " .. output.stderr, "error")
        end

        local count = 0
        for path in output.stdout:gmatch("[^\n]+") do
            emit("toggle", { Url(path), state = state })
            count = count + 1
        end

        if count == 0 then
            notify("No images found", "warn")
        else
            notify(string.format("%s %d image%s", state == "off" and "Deselected" or "Selected",
                count, count == 1 and "" or "s"))
        end
    end,
}
