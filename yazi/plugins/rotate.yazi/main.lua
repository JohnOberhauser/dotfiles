--- rotate.yazi — rotate images in place with ImageMagick
--- Usage (keymap.toml): run = "plugin rotate 90"   (90 = clockwise, 270 = counter-clockwise, 180 = flip)

local IMAGE_EXT = {
    jpg = true,
    jpeg = true,
    png = true,
    webp = true,
    gif = true,
    bmp = true,
    tif = true,
    tiff = true,
    avif = true,
    heic = true,
}

-- Runs on Yazi's main thread so it can read UI state (`cx`).
-- Returns selected files, or the hovered file if nothing is selected.
local get_targets = ya.sync(function()
    local tab = cx.active
    local targets = {}
    for _, url in pairs(tab.selected) do
        targets[#targets + 1] = tostring(url)
    end
    if #targets == 0 and tab.current.hovered then
        targets[1] = tostring(tab.current.hovered.url)
    end
    return targets
end)

local function is_image(path)
    local ext = path:match("%.([^%./]+)$")
    return ext ~= nil and IMAGE_EXT[ext:lower()] == true
end

local function notify(msg, level)
    ya.notify { title = "Rotate", content = msg, timeout = 3, level = level or "info" }
end

return {
    entry = function(_, job)
        local degrees = tonumber(job.args and job.args[1]) or 90
        local targets = get_targets()

        if #targets == 0 then
            return notify("Nothing to rotate", "warn")
        end

        local rotated, failed = 0, 0
        for _, path in ipairs(targets) do
            if is_image(path) then
                local output, err = Command("magick")
                    :arg("mogrify")
                    :arg("-rotate")
                    :arg(tostring(degrees))
                    :arg(path)
                    :stderr(Command.PIPED)
                    :output()

                if output and output.status.success then
                    rotated = rotated + 1
                else
                    failed = failed + 1
                    local reason = err and tostring(err) or (output and output.stderr) or "unknown error"
                    ya.err("rotate: " .. path .. ": " .. reason)
                end
            end
        end

        if failed > 0 then
            notify(string.format("Rotated %d, failed %d (see yazi log)", rotated, failed), "error")
        elseif rotated == 0 then
            notify("No images in selection", "warn")
        else
            notify(string.format("Rotated %d image%s %d°", rotated, rotated == 1 and "" or "s", degrees))
        end
    end,
}
