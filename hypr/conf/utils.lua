local last_mouse_scroll = 0
local DELAY = 300

local function throttled(action_fn)
    return function()
        local now = hl.time.now_ms() -- or os.clock() * 1000, whatever's available
        if now - last_mouse_scroll < DELAY then
            return
        end
        last_mouse_scroll = now
        action_fn()
    end
end
