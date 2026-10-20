local get_files = ya.sync(function()
    local tab, paths = cx.active, {}
    for _, u in pairs(tab.selected) do
        paths[#paths + 1] = tostring(u)
    end
    if #paths == 0 and tab.current.hovered then
        paths[1] = tostring(tab.current.hovered.url)
    end
    return paths
end)

return {
    entry = function()
        local files = get_files()
        if #files == 0 then
            return
        end

        local value, event = ya.input {
            pos = { "top-center", y = 3, w = 40 },
            title = "Date taken (YYYY-MM-DD):",
        }
        if event ~= 1 or not value or value == "" then
            return
        end

        if not value:match("^%d%d%d%d%-%d%d%-%d%d$") then
            ya.notify { title = "Photo date", content = "Invalid date: " .. value, timeout = 4, level = "error" }
            return
        end

        local stamp = value:gsub("-", ":") .. " 12:00:00"
        local output, err = Command("exiftool")
            :arg({ "-overwrite_original", "-AllDates=" .. stamp, "-FileModifyDate=" .. stamp })
            :arg(files)
            :output()

        if not output or not output.status.success then
            local msg = output and output.stderr or tostring(err)
            ya.notify { title = "Photo date", content = msg, timeout = 6, level = "error" }
        else
            ya.notify { title = "Photo date", content = string.format("Set %s on %d file(s)", value, #files), timeout = 3 }
        end
    end,
}
