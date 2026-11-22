local get_cwd = ya.sync(function()
    return tostring(cx.active.current.cwd)
end)

-- Drives whose "VENDOR MODEL" matches one of these (case-insensitive Lua patterns)
-- are only unmounted, never powered off — so a card reader stays alive for the next card.
local DEFAULT_UNMOUNT_ONLY = { "sd", "mmc", "card", "reader", "multi" }

local get_unmount_only = ya.sync(function(st)
    return st.unmount_only or DEFAULT_UNMOUNT_ONLY
end)

local function is_unmount_only(name, patterns)
    local n = name:lower()
    for _, p in ipairs(patterns) do
        if n:find(p:lower()) then
            return true
        end
    end
    return false
end

local function notify(content, level)
    ya.notify {
        title = "Eject",
        content = content,
        timeout = level == "error" and 8 or 4,
        level = level or "info",
    }
end

-- Run a command, capture output, never throw.
local function run(cmd, args)
    local c = Command(cmd):stdout(Command.PIPED):stderr(Command.PIPED):cwd("/")
    for _, a in ipairs(args) do
        c = c:arg(a)
    end
    local out, err = c:output()
    if not out then
        return false, string.format("%s: %s", cmd, tostring(err))
    end
    if not out.status.success then
        local msg = (out.stderr ~= "" and out.stderr or out.stdout):gsub("%s+$", "")
        return false, msg
    end
    return true, out.stdout
end

local function unescape(v)
    return (v:gsub("\\x(%x%x)", function(h) return string.char(tonumber(h, 16)) end))
end

-- Returns a list of removable drives that have at least one mounted filesystem.
local function list_drives()
    local ok, out = run("lsblk", {
        "-P", "-p", "-o", "NAME,PKNAME,TYPE,HOTPLUG,RM,TRAN,LABEL,SIZE,VENDOR,MODEL,MOUNTPOINT",
    })
    if not ok then
        return nil, out
    end

    local rows = {}
    for line in out:gmatch("[^\n]+") do
        local r = {}
        for k, v in line:gmatch('([%w_:]+)="(.-)"') do
            r[k] = unescape(v)
        end
        rows[#rows + 1] = r
    end

    local disks, order = {}, {}
    for _, r in ipairs(rows) do
        if r.TYPE == "disk" then
            local name = ((r.VENDOR or "") .. " " .. (r.MODEL or "")):gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
            disks[r.NAME] = {
                dev = r.NAME,
                name = name ~= "" and name or r.NAME,
                size = r.SIZE or "",
                removable = r.HOTPLUG == "1" or r.RM == "1" or r.TRAN == "usb",
                mounts = {},
            }
        end
    end

    for _, r in ipairs(rows) do
        local mp = r.MOUNTPOINT or ""
        if mp ~= "" and mp ~= "[SWAP]" then
            local parent = (r.PKNAME and r.PKNAME ~= "") and r.PKNAME or r.NAME
            local d = disks[parent]
            if d and d.removable then
                if #d.mounts == 0 then
                    order[#order + 1] = d
                end
                d.mounts[#d.mounts + 1] = { dev = r.NAME, path = mp, label = r.LABEL or "" }
            end
        end
    end

    return order
end

local KEYS = "123456789abcdfghiklmnoprstuvwxyz"

local function pick(drives)
    local cands = {}
    for i, d in ipairs(drives) do
        local labels = {}
        for _, m in ipairs(d.mounts) do
            labels[#labels + 1] = m.label ~= "" and m.label or m.path:match("[^/]+$")
        end
        cands[#cands + 1] = {
            on = KEYS:sub(i, i),
            desc = string.format(
                "%s  %s  [%s]%s",
                d.name,
                d.size,
                table.concat(labels, ", "),
                d.unmount_only and "  (unmount only)" or ""
            ),
        }
        if i == #KEYS then break end
    end
    return ya.which { cands = cands, silent = false }
end

-- If yazi is sitting inside the mount, move out so the watcher and the
-- process cwd don't keep the filesystem busy.
local function leave_mounts(drive)
    local cwd = get_cwd()
    for _, m in ipairs(drive.mounts) do
        if cwd == m.path or cwd:sub(1, #m.path + 1) == m.path .. "/" then
            local target = m.path:match("^(.*)/[^/]+$")
            if not target or target == "" then target = "/" end
            local emit = ya.emit or ya.mgr_emit or ya.manager_emit
            emit("cd", { target })
            ya.sleep(0.3)
            return
        end
    end
end

local function eject(drive)
    -- deepest mount first, in case of nested mounts
    table.sort(drive.mounts, function(a, b) return #a.path > #b.path end)

    for _, m in ipairs(drive.mounts) do
        local ok, err = run("udisksctl", { "unmount", "-b", m.dev })
        if not ok then
            -- one retry: busy is often transient (thumbnailers, watchers)
            ya.sleep(0.5)
            ok, err = run("udisksctl", { "unmount", "-b", m.dev })
        end
        if not ok then
            return false, string.format("Couldn't unmount %s:\n%s", m.path, err)
        end
    end

    if drive.unmount_only then
        return true
    end

    local ok, err = run("udisksctl", { "power-off", "-b", drive.dev })
    if not ok then
        return true, string.format("Unmounted, but power-off failed (still safe to unplug):\n%s", err)
    end
    return true
end

return {
    -- Optional, in init.lua:
    --   require("eject"):setup { unmount_only = { "sd", "card reader" } }
    setup = function(st, opts)
        opts = opts or {}
        st.unmount_only = opts.unmount_only
    end,

    entry = function()
        local drives, err = list_drives()
        if not drives then
            return notify("lsblk failed:\n" .. err, "error")
        end
        if #drives == 0 then
            return notify("No mounted USB drives", "warn")
        end

        local patterns = get_unmount_only()
        for _, d in ipairs(drives) do
            d.unmount_only = is_unmount_only(d.name, patterns)
        end

        local idx = pick(drives)
        if not idx then
            return
        end
        local drive = drives[idx]

        leave_mounts(drive)

        local ok, msg = eject(drive)
        if not ok then
            notify(msg, "error")
        elseif msg then
            notify(msg, "warn")
        elseif drive.unmount_only then
            notify(string.format("%s unmounted — safe to pull the card", drive.name))
        else
            notify(string.format("%s ejected — safe to remove", drive.name))
        end
    end,
}
